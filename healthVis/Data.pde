class Data {

  float maxTotal;
  float minTotal;
  int x;
  float maxHeight;
  Table table;
  int col;
  float [] y = new float [years];
  String name;
  color c;
  int s;

  void init (String tableName, int tempCol) {

    col = tempCol;
    table = loadTable(tableName);
    name = table.getString(0, col);
    table.removeTitleRow(); // Set first row as header row
    maxTotal = table.getFloat(years-1, col);
    minTotal = table.getFloat(0, col);

    for (TableRow row : table) {

      if (maxTotal < row.getFloat(col)) {
        maxTotal = row.getFloat (col);
      }

      if (minTotal > row.getFloat(col)) {
        minTotal = row.getFloat (col);
      }
    }

    maxHeight = (3.4*(maxTotal-minTotal)) / (table.getFloat(1, col) - table.getFloat(0, col));
  }

  void parse (int tempX, int _s) {

    s = _s;
    x = tempX;
    text (name, -50, x);


    for (int i = 0; i < years; i++) {
      

      
      if (col == 0) {
        
       float temp = table.getFloat (i, col);
       temp = map (temp, minTotal, maxTotal, 0, maxHeight);
      temp = height-temp;
      //ellipse (temp, y, s, s);
      y [i] = temp-60;
      
      } else {
      
       float temp = ((table.getFloat(i,col) * 100) / table.getFloat(0,col))-100;
             temp = map (temp, 0, 1100, 0, maxHeight);
      temp = height-temp;
      //ellipse (temp, y, s, s);
      y [i] = temp-60;
      
      }
      

      
    }
  }

  void display () {
    strokeWeight(1);
    stroke (255);
    for (int i = 0; i < years; i++) {
      line (x, y[i]-s, x, y[i]+s);
    }
  }
}

