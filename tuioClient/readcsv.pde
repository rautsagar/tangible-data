/* Part of the TUIO client*/


class ReadCSV {
  String filePath;
  int length;  //Number of rows in the dataset
  int columns; //Number of columns in the dataset
  String[] lines;  //Read all the rows from the CSV here
  float[] max;
  float[] min;
  float[] range;
  String[] dimensions;   //names of all the data dimensions
  
  ReadCSV(String path) {
    filePath = path;
    lines = loadStrings(filePath);      
    length = lines.length-1;        //read number of rows 
    
    String[] tokens = split(lines[0], ",");
    columns =  tokens.length;      //read number of columns 
    println("the data has: "+length+"rows and "+ columns+ " columns");
    max = new float[columns];
    min = new float[columns];
    range = new float[columns];
  }

  String getEntry(int line, int column) {

    String[] tokens = split(lines[line], ",");
    return tokens[column - 1];
  }

  
  DataPoint[] getPoints() {

    DataPoint[] points = new DataPoint[length];
    
    String[] token0 = split(lines[0], ",");  //Get the titles from the first row
    dimensions = new String[columns - 1];
    arrayCopy(token0, 1, dimensions, 0, columns-1);   //copy dimension names except "name"
    
    String[] tokens1 = split(lines[1], ",");        //get values in the first row
    
    
    for (int k = 0; k < 9; k++) {                  //Pre-populate the min and max arrays
      max[k] = 0;
      min[k] = Float.parseFloat(tokens1[k+1]);
    }

    println("Loading points..");

    for (int i = 0; i<length; i++) {              //Iterate row-by-row and populate datapoints with dimension values

      String[] tokens = split(lines[i+1], ",");
      float[] values = new float[9];
      String name = tokens[0];
      
      for (int k = 0, j = 1; k < 9; k++, j++) { 
        values[k] = Float.parseFloat(tokens[j]);

        if (values[k] > max[k]) {
          max[k] = values[k];
        }
        if (values[k] < min[k]) {
          min[k] = values[k];
        }
      }



      points[i] = new DataPoint(name, dimensions, values);
    }

    for (int k = 0; k < 9; k++) {
      range[k] = max[k] - min[k];

//      print("max: "+ max[k]);
//      println("min: "+ min[k]);

    }

    println(length + " Points loaded");

    return points;
  }
}

