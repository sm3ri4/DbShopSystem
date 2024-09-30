using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Net.Mime.MediaTypeNames;

namespace ShopDb{
    public partial class EnterParametres : Form{

        private string _reportType;
        public EnterParametres(string reportType){
            InitializeComponent();
            this._reportType = reportType;

            switch (_reportType){
                case "Скидки клиентов":{
                        richTextBox1.Text += "Введите дату";
                        break;
                    }
                case "Динамика продажи товара":{
                        richTextBox1.Text += "Введите период и артикул товара через ';'";
                        break;
                    }
                case "Дни рождения покупателей":{
                        richTextBox1.Text += "Введите дату";
                        break;
                    }
                default: break;
            }
        }

        private void button1_Click(object sender, EventArgs e){
            var text = textBox1.Text;

            switch (_reportType){
                case "Скидки клиентов":{
                        Reports report = new Reports(text, this._reportType);
                        break;
                    }
                case "Динамика продажи товара":{
                        var defs = text.Split(';');
                        Reports report = new Reports(defs[0] + ";" + defs[1], this._reportType, defs[2]);
                        break;
                    }
                case "Дни рождения покупателей":{
                        Reports report = new Reports(text, this._reportType);
                        break;
                    }
                default:break;

            }
            this.Close();
        }
    }
}
