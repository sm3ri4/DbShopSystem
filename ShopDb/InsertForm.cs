using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Windows.Forms.VisualStyles;

namespace ShopDb{
    public partial class InsertForm : Form{
        public InsertForm(){
            InitializeComponent();
        }

        private string _table;
        public InsertForm(string table){
            InitializeComponent();

            Database dbase = new Database();

            string command = $"select * from {table}";

            StyledDataGrid dataGrid = new StyledDataGrid();
            dataGrid.DataSource = dbase.Select(command);
            panel1.Controls.Add(dataGrid);
            
            _table = table;

            richTextBox1.Text += "Введите значения через запятую, соблюдая синтаксис написания значений для разных типов данных";
        }

        private void button1_Click(object sender, EventArgs e) {
            var values = textBox1.Text;

            Database dbase = new Database();
            string command = $"insert into {_table} values({values})";
            dbase.Insert(command);

            this.Close();
        }
    }
}
