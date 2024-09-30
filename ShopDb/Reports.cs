using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace ShopDb{
    internal class Reports {

        private string _condition;
        private string _reportType;
        private delegate void ReportType();
        private string _itemNumber;
        private Dictionary<string, ReportType> _reports;


        public Reports(string condition, string reportType, string itemNumber = null){
            this._condition = condition;
            this._reportType = reportType;
            this._itemNumber = itemNumber;
            _reports = new Dictionary<string, ReportType> {
                                                             {"Скидки клиентов", new ReportType(ClientsDiscount10)},
                                                             {"Динамика продажи товара", new ReportType(SaleDynamic)},
                                                             {"Дни рождения покупателей", new ReportType(ClientBitrhday)}
                                                          };

            _reports[reportType].Invoke();
        }

        private void ClientsDiscount10(){
            string command = "select distinct itemsale.datesale, client.clientid, client.clientname, client.clientphone, clientdiscount.discountnumber, clientdiscount.purchasesum, clientdiscount.discountvalue" +
                             " from ((itemsale join client " +
                                              "on client_clientid = client.clientid) join clientdiscount " +
                                                                                   "on clientdiscount_discountnumber=clientdiscount.discountnumber)" +
                                                                                   $" where discountvalue=10 and datesale<={_condition}";
            Execute(command);
        }

        private void SaleDynamic(){
            var dateInterval = _condition.Split(';');
            string dateStart = dateInterval[0];
            string dateEnd = dateInterval[1];
            string itemNumber = this._itemNumber;

            string command = "select date_trunc('month', itemsale.datesale)::date as month, " +
                                   "sum(itemsale.countsale) as totalsales " +
                            "from itemsale " +
                            "join itemposition on itemposition_itempositionnumber=itemposition.itempositionnumber " +
                            "join invoice on invoice_invoicenumber=invoice.invoicenumber " +
                            "join item on item_itemid=item.itemid " +
                            $"where invoice.invoicedate>={dateStart} " +
                            $"and datesale<={dateEnd} and item.itemarticle={itemNumber} " +
                            "group by month " +
                            "order by month";

            Execute(command);
        }

        private void ClientBitrhday(){
            string command = "select clientname, clientborndate, clientphone from client " +
                             "where extract(doy from clientborndate) " +
                             $"between extract(doy from {_condition}::date) and " +
                             $"extract(doy from {_condition}::date + interval '10 days')";

            Execute(command);
        }

        private void Execute(string command){

            Database dbase = new Database();
            StyledDataGrid dataGrid = new StyledDataGrid();
            dataGrid.DataSource = dbase.Select(command);
            ReportForm report = new ReportForm(dataGrid);
            report.ShowDialog();
        }


    }
}
