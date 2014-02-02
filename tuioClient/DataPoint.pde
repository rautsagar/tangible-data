class DataPoint {
  pt loc;
  pt dest; 
  vec v;
  
  String name;  
  HashMap<String, Float> dataval;
  HashMap<String, Float> normdata;
  boolean line = false;
  String[] attrNames;

  // CREATE
  DataPoint() {
    loc = new pt();    
    dest = null;
    v = V(0,0);
  }


  DataPoint(String title, String[] names , float[] vals) {
    name = title;
    //normalizing values
    loc = new pt();     //initialize the location as the point
    attrNames = names;
    dest = null;
    v = V(0, 0);
    dataval = new HashMap<String, Float>();
    
    for(int i = 0; i < vals.length; i++){
      println("Inserting" + names[i]);
      dataval.put(names[i], vals[i]);
    }
    
//    dataval.put("proteins", pro);
//    dataval.put("fats", fat); 
//    dataval.put("sodium", sod); 
//    dataval.put("fiber", fib); 
//    dataval.put("carbs", car); 
//    dataval.put("sugars", sug); 
//    dataval.put("potassium", pot); 
//    dataval.put("vitamins", vit);
  }   
  
  DataPoint (DataPoint otherPoint){    
    name = otherPoint.name;
    String[] attrib = otherPoint.attrNames;
    //normalizing values
    if(otherPoint.loc != null)
      loc = P(otherPoint.loc);
    if(otherPoint.dest != null)
      dest = P(otherPoint.dest);   
      
    v = V(otherPoint.v);
    
    normdata = new HashMap<String, Float>();
    for(int i = 0; i < 9; i++){
      String dimName = attrib[i];
      normdata.put(dimName, otherPoint.getNormalizedValue(dimName));
    }
//    normdata.put(attr.get(0), otherPoint.getNormalizedValue(attr[0]));
//    normdata.put(attr[1], otherPoint.getNormalizedValue(attr[1]));
//    normdata.put(attr[2], otherPoint.getNormalizedValue(attr[2])); 
//    normdata.put(attr[3], otherPoint.getNormalizedValue(attr[3])); 
//    normdata.put(attr[4], otherPoint.getNormalizedValue(attr[4])); 
//    normdata.put(attr[5], otherPoint.getNormalizedValue(attr[5])); 
//    normdata.put(attr[6], otherPoint.getNormalizedValue(attr[6])); 
//    normdata.put(attr[7], otherPoint.getNormalizedValue(attr[7])); 
//    normdata.put(attr[8], otherPoint.getNormalizedValue(attr[8]));   
    
  }


  //Normalize each data in a range from 0-1
  void fillNorm(float[] min, float[] range, String[] names) {
    //    println("Filling normalized values");

    //Switched these over to normalized in the range of 0-1, making vector manipulation much easier
    normdata = new HashMap<String, Float>();
    float normalizedMax = 1f;
    
    
    for(int i = 0; i < names.length; i++){
      
      normdata.put(names[i], ((dataval.get(names[i])-min[i])*normalizedMax)/range[i]);
    }
//    normdata.put("calories", ((dataval.get("calories")-min[0])*normalizedMax)/range[0]);
//    normdata.put("proteins", ((dataval.get("proteins")-min[1])*normalizedMax)/range[1]);
//    normdata.put("fats", ((dataval.get("fats")-min[2])*normalizedMax)/range[2]);
//    normdata.put("sodium", ((dataval.get("sodium")-min[3])*normalizedMax)/range[3]);
//    normdata.put("fiber", ((dataval.get("fiber")-min[4])*normalizedMax)/range[4]);
//    normdata.put("carbs", ((dataval.get("carbs")-min[5])*normalizedMax)/range[5]);
//    normdata.put("sugars", ((dataval.get("sugars")-min[6])*normalizedMax)/range[6]);
//    normdata.put("potassium", ((dataval.get("potassium")-min[7])*normalizedMax)/range[7]);
//    normdata.put("vitamins", ((dataval.get("vitamins")-min[8])*normalizedMax)/range[8]);

    //    for (String key : normdata.keySet()) {
    //      println(normdata.get(key));
    //    }
  }

  //Get normalized value for a DataPoint
  float getNormalizedValue(String attr) {
    return normdata.get(attr);

  }

  //Specify which data valued to use as a co-ordinate
  void setloc(String colX, String colY, float bias) {
    //println("Using " + colX + " & " + colY);
    loc = P(dataval.get(colX)+bias, dataval.get(colY)+bias);
  }


  //Explicitly set the location
  void setloc(float X, float Y) {
//    println("Explicitly setting the location");

    loc = P(X, Y);
  } 
  
    //Explicitly set the location
  void setloc(pt p) {
//    println("Explicitly setting the location");

    loc = P(p);
  } 

  //move the points by a certain value
  void showpt() {
    if (!line){    
      stroke(0, 200);
      strokeWeight(1);
      ellipse(loc.x, loc.y, 6, 6);
    }
    else
      line(loc.x, loc.y, dest.x, dest.y);
  }
  
  void showInfo() {
    text(name, loc.x + 5, loc.y);
    
  }

  //move the points by a certain value
  void showpt(float bias) {
    if (!line)
      ellipse(loc.x, loc.y, 6, 6);
    else
      line(loc.x, loc.y, dest.x, dest.y);
  }

  //accepts the center of the fiducial, and sets a vector from  the current point to the fiducial
  void setvec(pt fidPt, String attr) {

    //    println("calculating vector");
    v = U(V(loc, fidPt));
    v.scaleBy(normdata.get(attr));
  }

  void setLine(pt start, pt end) {
    line = true;
    loc = P(start);
    dest = P(end);
    v = U(loc, dest);
  }


  void setDest(pt destination) {
    dest = destination;
  }

  void updateDest(pt destination, String attr) {
    if (dest == null)    
      dest = L(loc, destination, getNormalizedValue(attr));
    else
      dest = L(dest, destination, getNormalizedValue(attr));
  }

  void showvec() {
    fill(0);
    show(loc, v);
  }

  //Update the vector based on the newest destination and move towards it
  void updateAndMove(float speed) {
    if (!line) {
      if (dest != null) {
        if (d(loc, dest) > 5)
          v = U(loc, dest);
        else 
          v.zero();    
        loc = P(loc, mul(v, speed));
      }
      else {
        dest = loc;
        v = V(0, 0);
      }
    }
  }

  //Move the datapoint in the direction of the fiducial
  void move(float speed) {
    if (!line) {
      loc = P(loc, mul(v, speed));
      dest = loc;
    }
  }
}

