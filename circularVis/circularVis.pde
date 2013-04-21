String [] terms = {"Hugo_Chavez", "Barack_Obama", "Pope_Benedict_XVI", "Kim_Jong-un"};
color c1 = color (0, 255, 0, 100);
color c2 = color (255, 0, 0, 100);
color c3 = color (0, 0, 255, 100);
color c4 = color (255, 255, 0, 100);
color c5 = color (255, 0, 255, 100);
color c6 = color (0, 255, 255, 100);
String request;
String [] dates = new String [0];;
//color c3 = color (0, 255, 0);

color [] colors = {c1, c2, c3, c4, c5, c6};

int [][] data = new int [terms.length][0];

//import JSON library 
import org.json.*;

PFont font;

int maxValue;
int maxMap;

float xPos, yPos;
float firstXPos, firstYPos;

import processing.pdf.*;

void setup() {

  size (1280, 800);
  background (255);
  
  String[] fontList = PFont.list();
  font = createFont (fontList[296], 48);   
  
  translate (width/2, height/2);
  //rotate (radians(-90));
  
  noLoop();
  beginRecord(PDF, "filename.pdf");
  textFont (font);

  //We'll make a separate function to parse through the JSON
  getJson();
  maxMap();
  
  stroke (100);
  strokeWeight (0.1);
  noFill();
  drawCircles ();
  drawDates ();
  
  noStroke();
  
  // The following sequences of if statements provides the capping value
  // for the graphic. This is used because some pages will have viewcounts
  // in the tens of thousands and others in the hundreds
  if (maxValue > 10) maxMap = 100;
  if (maxValue > 100) maxMap = 1000;
  if (maxValue > 1000) maxMap = 5000;
  if (maxValue > 5000) maxMap = 10000;
  if (maxValue > 10000) maxMap = 20000;
  if (maxValue > 20000) maxMap = 40000;
  if (maxValue > 40000) maxMap = 100000;
  
  //draw your bar graph using the data you pulled
  
  fill (255, 0, 0, 100);
  graph ();
  
  translate (- width/2, - height/2);
  textAlign (CORNER);
  //Write the term you're searching for
  for (int i=0; i<terms.length; i++){
  textFont (font);
  textSize (12);
  fill (colors[i]);
  rect (0, i*30, 30, 20);
  fill (50);
  text (terms[i], 40, i*30 + 15);
  
  }
  /*//Write the capping values for your data
  textAlign (RIGHT);
  text ("0", width - 40, height - 20);
  text (maxMap, width-20, 40);*/
  
};

void draw() {
  
  endRecord();
  
};

void getJson() {

  
  for (int i = 0; i < terms.length; i++) {
  //Pull the string from the website, using the format provided
  //adding the searched term after the URL
  request = "http://stats.grok.se/json/en/latest90/" + terms[i];
  
  /* This is the tricky part:
   In a JSON file, everything inside curly brackets is a JSON Object
   Everything inside square brackets is a JSON Array
   Here we'll be pulling data from a JSON object WITHIN another.
   */
  
  //call the first JSON Object. In this case it wraps around the entire document
  JSONObject views = new JSONObject(join(loadStrings( request ), ""));
  
  //call the second JSON Object, within "views", that we just created
  //this one is called "daily_views" in the original document
  JSONObject results = views.getJSONObject("daily_views");
  
  //If we wanted to pull data from a JSON Array, the code would look like this
  //JSONArray results = wikiData.getJSONArray("results");
  
  // 3 For Loops, one for year, one for month, one for day, 
  // this way we can use the same code for longer datasets
  for (int year = 2012; year <= 2013; year++) {
    for (int m = 1; m <=12; m++) {
      for (int d = 1; d <= 31; d++) {
        
        // total visits in that day
        int total;
        
        //this is done to add the 0 that sometimes appears in the file, such as in july (07)
        String month, day;

        if (d < 10) { 
          day = "0"+ d;
        } 
        else { 
          day = "" + d;
        }

        if (m < 10) { 
          month = "0"+m;
        } 
        else { 
          month = "" + m;
        }
        
        //You now have everything you need
        //PULL that data out of the JSON File
        String date = year +"-"+ month + "-" + day;
        
          if (m == 1) month = " Jan ";
          if (m == 2) month = " Feb ";
          if (m == 3) month = " Mar ";
          if (m == 4) month = " Apr ";
          if (m == 5) month = " May ";
          if (m == 6) month = " Jun ";
          if (m == 7) month = " Jul ";
          if (m == 8) month = " Aug ";
          if (m == 9) month = " Sep ";
          if (m == 10) month = " Oct ";
          if (m == 11) month = " Nov ";
          if (m == 12) month = " Dec ";
        
        String writeDate = month +  day + " " + year;
        total = results.getInt(date);
        
        
        // If your code looks for something that doesn't exist
        // such as February 30, it'll return -1. 
        // In that case, do not add this value to your array
        if (total != -1) {  
          data[i] = append(data[i], total);
          if (i == 0) dates = append (dates, writeDate);
        }
        
        if (total > maxValue) maxValue = total;
        
      }
      
      // see your array in the console :)
      // Now go back up and play with the numbers
      println (data[i]);
    }
  }
  }
};

void drawCircles () {
  
  for (int i = 0; i <= 5000; i += 150) {
   
   noFill ();
   ellipse (0, 0, i, i);
   
   fill (200);
   textAlign (CENTER);
   textSize (10);
   float count = map (i, 0, 1500, 0, maxMap);
   text ((int)count, 0, -i/2 - 5);
   println (count);
    
  }
}
  
void drawDates () {
 for (int i=0; i < dates.length; i++) {
   
  pushMatrix();
  
  float deg = map (i, 0, dates.length, 0, 360);
  float angle = radians(deg);
  int radius = 1280;
  xPos = cos (angle) * (radius);
  yPos = sin (angle) * (radius);

  line (0, 0,  xPos, yPos);
  rotate (angle);
  
  textAlign (CENTER);
  textSize (10);
  text (dates[i], 200+i*5, 5);
  
  popMatrix();
  
  
}
  
}

void maxMap () {
 
   if (maxValue > 10) maxMap = 100;
  if (maxValue > 100) maxMap = 1000;
  if (maxValue > 1000) maxMap = 5000;
  if (maxValue > 5000) maxMap = 10000;
  if (maxValue > 10000) maxMap = 20000;
  if (maxValue > 20000) maxMap = 40000;
  if (maxValue > 40000) maxMap = 100000;
  
}
