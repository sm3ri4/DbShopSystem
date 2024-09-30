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
    public partial class DeleteForm : Form{
        public DeleteForm(){
            InitializeComponent();
        }

        private string _table;
        public DeleteForm(string table){
            InitializeComponent();
            this._table = table;

            Database dbase = new Database();
            panel1.Controls.Add(new StyledDataGrid());
            (panel1.Controls[0] as StyledDataGrid).DataSource = dbase.Select($"select * from {table}");

        }

        private void button1_Click(object sender, EventArgs e){
            Database dbase = new Database();
            string firstColumn = dbase.GetTableTitles(_table)[0];
            string command = $"delete from {_table} where {firstColumn}={textBox1.Text}";
            dbase.Delete(command);
            this.Close();
        }
    }
}
