using Npgsql;
using System.Data;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Linq;

namespace ShopDb{
    internal class Database{
        private string _connectionString = "Server=localhost;Port=5432;User Id=postgres;Password=admin;Database=ShopDb;";
        private NpgsqlConnection _connection;
        private NpgsqlCommand _command;

        public Database() {
            this._connection = new NpgsqlConnection(_connectionString);
        }

        public void Update(string command){
            this._connection.Open();
            this._command = new NpgsqlCommand();
            this._command.Connection = this._connection;
            this._command.CommandText = command;
            this._command.ExecuteNonQuery();
            MessageBox.Show("Запись успешно обновлена.");
            this._connection.Close();
        }

        public void Delete(string command){
            this._connection.Open();
            this._command = new NpgsqlCommand();
            this._command.Connection = this._connection;
            this._command.CommandText = command;
            this._command.ExecuteNonQuery();
            MessageBox.Show("Запись успешно удалена.");
            this._connection.Close();
        }

        public void Insert(string command){
            this._connection.Open();
            this._command = new NpgsqlCommand();
            this._command.Connection = this._connection;
            this._command.CommandText = command;
            this._command.ExecuteNonQuery();
            MessageBox.Show("Запись успешно добавлена.");
            this._connection.Close();
        }

        public DataTable Select(string command){

            this._connection.Open();
            this._command = new NpgsqlCommand();
            this._command.Connection = this._connection;
            this._command.CommandText = command;
            var reader = this._command.ExecuteReader();
            var titles = reader.GetTitles();

            var output = new List<List<string>>{
                new List<string>(titles)
            };

            while (reader.Read()){
                var list = new List<string>();

                for (int i = 0; i < reader.FieldCount; i++)
                    list.Add(reader.GetValue(i).ToString());

                output.Add(new List<string>(list));
            }

            this._connection.Close();

            return CreateTable(output);
        }

        public string[] GetTableTitles(string table){

            this._connection.Open();
            this._command = new NpgsqlCommand();
            this._command.Connection = this._connection;
            this._command.CommandText = $"select * from {table}";
            var reader = this._command.ExecuteReader();
            var titles = reader.GetTitles();
            this._connection.Close();

            return titles;
        }

        public string GetFirstString(string table){

            this._connection.Open();
            this._command = new NpgsqlCommand();
            this._command.Connection = this._connection;
            this._command.CommandText = $"select * from {table}";
            var reader = this._command.ExecuteReader();
            var output = reader.GetFirstRow();
            this._connection.Close();

            return string.Join("; ", output);
        }

        private DataTable CreateTable(List<List<string>> schema){
            DataTable table = new DataTable();
            
            for(int i = 0; i < schema[0].Count; i++)
                table.Columns.Add(new DataColumn(schema[0][i]));

            for(int i = 1; i < schema.Count; i++)
                table.Rows.Add(schema[i].ToArray());

            return table;
        }
    }

    public static class NpgsqlExtension{
        public static string[] GetTitles(this NpgsqlDataReader reader){
            string[] titles = new string[reader.FieldCount];

            for(int i = 0; i < titles.Length; i++)
                titles[i] = reader.GetName(i);

            return titles;
        }

        public static string[] GetFirstRow(this NpgsqlDataReader reader){
            string[] row = new string[reader.FieldCount];

            reader.Read();
            for (int i = 0; i < reader.FieldCount; i++)
                row[i] = reader.GetValue(i).ToString();

            return row;
        }
    }

}
