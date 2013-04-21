/***************************
 Parsing Data from TSV (tabular separated values) tables
 by Bernardo Schorr - 2013
 
 There's a custom class built for our purposes. The code walks through its methods.
 
 ****************************/

int years;
int w, h;
Data [] data;
color c1, c2;
PFont font, font2;
Table table;
Table table2;
color titleColor;
boolean isHoverTrue;



void setup () {

  size (displayWidth, displayHeight);

  smooth();
  table = loadTable("data.txt");
  table2  = loadTable ("data2.txt");
  //table.removeTitleRow(); // Set first row as header row
  table2.removeTitleRow(); // Set first row as header row
  data = new Data [table.getColumnCount()];
  years = table.getRowCount()-1;
  c1 = color (255, 255, 0);
  c2 = color (255, 0, 0);
  font = loadFont("GothamHTF-Light-48.vlw");
  font2 = loadFont ("GothamHTF-ThinItalic-48.vlw");
  titleColor = color (200);

  //colorMode (HSB);

  background (0);
  w = 1280;
  h = 800;

  for (int i = 0; i < data.length; i++) {
    data[i] = new Data();
  }

  for (int i =  0; i < data.length; i++) {
    data[i].init("data.txt", i);

    //if (i == 1) data[0].maxHeight = data[i].maxHeight;
    if (i == 1) data[0].maxHeight = 300;
  }

  stroke (255);

  data [0].parse (80, 2);
  for (int i = 1; i < data.length; i++) {
    data[i].parse (i*300, 2);
  }

  /*
  Below is the code for drawing the curves between nodes.
   I wouldn't worry too much about it just now... I can answer questions tomorrow, if you have them.
   */
}

void draw () {
  
  String popLabel;
  String gdpLabel;
  String healthLabel;
  String lifeLabel;

  background(0);
  drawCurves();
  for (int i = 1; i < data.length; i++) {
    data[i].display ();
  }
  
  for (int i = 0; i < data[0].y.length; i += 10){
  
  fill (50);
  textFont(font, 10);
  text (data[0].table.getInt(i,0), 40, data[0].y[i]+4);
  }
  
  text (data[0].table.getInt(49,0), 40, data[0].y[49]+4);
  
  String title = "THE RISING COST OF HEALTH"; 
  fill (titleColor);
  textFont (font2, 24);
  text (title, 80, 80 );
  if (!isHoverTrue) text ("1960-2009", 80, 120);
  
  popLabel="Population";
  gdpLabel="GDP";
  healthLabel="Health Expenditures";
  lifeLabel="Life Expectancy";
  
  fill(200);
  textFont(font,12);
  text(popLabel, 235, displayHeight-40);
  text(gdpLabel, 575, displayHeight-40);
  text(healthLabel, displayWidth-500, displayHeight-40);
  text(lifeLabel, displayWidth-175,displayHeight-40);
  
  
  
  
  if (!isHoverTrue) {  
     
  //fill (titleColor);
  //textFont (font2, 24); 
  
    
   String [] lines = new String [6];
    
     lines[0] = "This is a dynamic visualization of";
     lines[1] = "Health Expenditure growth in the US since 1960."; 
     lines[2] = "Hover over any year of the diagram to compare";
     lines[3] = "the increase rate of Health Expenditure in ";
     lines[4] = "relation to population, national GDP, ";
     lines[5] = "and life expectancy.";
    
    textFont (font, 16);
    
    for (int j = 0; j<5; j++){ 
    
    text (lines[j], 80, j*25+160);

    } 
    
    
  }
  
  
}

void drawCurves () {

  noFill();

  for (int i = 0; i < years; i++) {


    /*
    strokeWeight (0.5);
     line (0, data[0].y[i], data[1].x, data[0].y[i]);
     */

    stroke (50);
    hover(i);
    strokeWeight(0.5);

    beginShape();

    vertex(data[0].x, data[0].y[i]);

    for (int j = 0; j < 1; j++) {

      float nextPoint = data[j+1].y[i];
      float conPoint = (data[j+1].x + data[j].x)/2;

      bezierVertex(conPoint, data[j].y[i], conPoint, nextPoint, data[j+1].x, nextPoint);
    }

    endShape();


    float lerpVal = map (i, 0, years, 0, 1);
    color c = lerpColor (c1, c2, lerpVal);
    stroke (c);

    strokeWeight(2);
    hover(i);
    
    
    beginShape();

    vertex(data[1].x, data[1].y[i]);

    for (int j = 1; j < data.length-1; j++) {

      float nextPoint = data[j+1].y[i];
      float conPoint = (data[j+1].x + data[j].x)/2;

      bezierVertex(conPoint, data[j].y[i], conPoint, nextPoint, data[j+1].x, nextPoint);
    }

    endShape();
  }
}

void hover (int _i) {

  int i = _i;

  if (mouseY > displayHeight - 360 && mouseY < displayHeight-60 && mouseX < width/4) {

    int hover = int (map(mouseY, displayHeight - 360, displayHeight-60, years, 0));
    //println (data[0].table.getInt(hover, 0));
    int hoverYear = data[0].table.getInt(hover, 0);
    int currentYear = data[0].table.getInt(i, 0);

    if (hoverYear == currentYear) {
      stroke (255);
      strokeWeight (5);
      //text (hoverYear, 40, data[0].y[i]+5);
      
      
      fill (200);
      String stringYears = "" + table2.getInt(i, 0);      
      String stringPop = "" + table2.getString(i, 1) +".000";
      String stringGdp = "US$ " + table2.getString(i, 2)+ " (billion)";
      String stringHealth = "US$ " + table2.getString(i, 3)+" (billion)";
      String stringLife = "" + table2.getString(i, 4) + " years";
      
      float perc1 = ((table.getFloat(i+1,1) * 100) / table.getFloat(1,1))-100;
      float perc2 = ((table.getFloat(i+1,2) * 100) / table.getFloat(1,2))-100;
      float perc3 = ((table.getFloat(i+1,3) * 100) / table.getFloat(1,3))-100;
      float perc4 = ((table.getFloat(i+1,4) * 100) / table.getFloat(1,4))-100;
     
      String stringPopPerc = String.format ("%.2f", perc1);
      String stringGdpPerc = String.format ("%.2f", perc2);
      String stringHealthPerc = String.format ("%.2f", perc3);
      String stringLifePerc = String.format ("%.2f", perc4);
      
      stringPopPerc = "Population: " + stringPopPerc + "% more than in 1960";      
      stringGdpPerc = "GDP: " +stringGdpPerc + "% more than in 1960";
      stringHealthPerc = "Health Expenditure: " + stringHealthPerc + "% more than in 1960";
      stringLifePerc = "Life Expectancy: " + stringLifePerc + "% more than in 1960";
      
      
      
      textFont(font, 24);
      text (stringYears, 80, 120);
      /*
      textFont(font, 16);
      text (stringPop, 60, 140);
      text (stringGdp, 60, 200);
      text (stringHealth, 60, 260);
      text (stringLife, 60, 320);
      
      fill (120);
      text (stringPopPerc, 60, 160);
      text (stringGdpPerc, 60, 220);
      text (stringHealthPerc, 60, 280);
      text (stringLifePerc, 60, 340);
      
      noFill();
     */
     
     fill (120);
      textFont(font, 16);
      text (stringHealth, 80, 180);
      text (stringGdp, 80, 240);
      text (stringPop, 80, 300);
      text (stringLife, 80, 360);
      
      fill (200);
      text (stringHealthPerc, 80, 160);
      text (stringGdpPerc, 80, 220);
      text (stringPopPerc, 80, 280);
      text (stringLifePerc, 80, 340);
      
      noFill();
      titleColor = color (70);
      isHoverTrue = true;
      
    }
  } 
  else { 

    strokeWeight (2);
    titleColor = color (200);
    isHoverTrue = false;
    
    
  }
}

