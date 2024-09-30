using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;


namespace ShopDb{
    public partial class Form1 : Form{

        static Dictionary<string, string> tables = new Dictionary<string, string> {
            {"Магазины", "shop"},
            { "Накладные", "invoice"},
            { "Товары", "item"},
            { "Позиции товаров", "itemposition"},
            { "Единицы измерения валюты", "itemmeasure" },
            { "Тип товаров", "itemtype"},
            { "Продажа товаров", "itemsale" },
            { "Покупатели", "client" },
            { "Паспорта покупателей", "clientpassport" },
            { "Скидки покупателей","clientdiscount" }
        };

        List<string> reports = new List<string>() { {"Скидки клиентов"},
                                                    {"Динамика продажи товара"},
                                                    {"Дни рождения покупателей"}
                                                };


        public Form1(){
            InitializeComponent();
            comboBox1.Items.AddRange(tables.Keys.ToArray());
            comboBox2.Items.AddRange(tables.Keys.ToArray());
            comboBox3.Items.AddRange(tables.Keys.ToArray());
            comboBox4.Items.AddRange(tables.Keys.ToArray());
            comboBox5.Items.AddRange(reports.ToArray());
        }

        private void button2_Click(object sender, EventArgs e){
            var name = comboBox2.Text;
            
            if (name == "") 
                return;

            var tableName = tables[name];

            InsertForm insertForm = new InsertForm(tableName);
            insertForm.ShowDialog();
            comboBox2.Text = null;
        }

        private void button3_Click(object sender, EventArgs e){
            var name = comboBox3.Text;

            if (name == "")
                return;

            var tableName = tables[name];

            DeleteForm delete = new DeleteForm(tableName);
            delete.ShowDialog();
            comboBox3.Text = null;
        }

        private void button4_Click(object sender, EventArgs e){
            var name = comboBox4.Text;
            if (name == "")
                return;

            var tableName = tables[name];

            UpdateForm update = new UpdateForm(tableName);
            update.ShowDialog();

            comboBox4.Text = null;
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e){
            panel2.Controls.Clear();
            panel2.Controls.Add(new StyledDataGrid());

            var name = comboBox1.Text;

            if (name == "")
                return;

            var tableName = tables[name];

            Database dbase = new Database();
            string command = $"select * from {tableName}";
            (panel2.Controls[0] as StyledDataGrid).DataSource = dbase.Select(command);
        }

        private void button1_Click(object sender, EventArgs e){
            if (comboBox5.Text == "")
                return;

            var type = comboBox5.Text;
            EnterParametres enter = new EnterParametres(type);
            enter.ShowDialog();
            
        }
    }
}
