

class MergeSort{
    
  DataPoint[] array;
  String attr;
  
  void printArray(){
    for(int i = 0; i < array.length; i++){
      print(array[i] + ", ");
    }
  }
    public MergeSort(DataPoint[] arr, String attribute){
        array = arr;
        attr = attribute;
    }
    
    void MSort(int left, int right){
    int length = right - left + 1;

    if(length <= 1){
      return;
    }

    int mid = (left + right)/2;

    //Recursive calls
    MSort(left, mid);
    MSort(mid + 1, right);
                Merge(left, mid, right);

  }

  void Merge(int left, int mid, int right){
    //Assumption: Left and right will always be adjecant
    int lLeft = mid - left + 1;
    int lRight = right - mid;
    int lMerged = lLeft + lRight;
    int lP = 0, rP = 0, mP = 0;

    DataPoint[] merged = new DataPoint[lLeft + lRight];

    while(lP < lLeft && rP < lRight){
      if(array[left + lP].dataval.get(attr) <= array[mid + 1 + rP].dataval.get(attr)){
        merged[mP] = array[left + lP];
        lP++;
        mP++;

      }else{
        merged[mP] = array[mid + 1 + rP];
        rP++;
        mP++;

      }

    }

    while(lP < lLeft){
      merged[mP] = array[left + lP];
        lP++;
        mP++;

    }
    while(rP < lRight){
      merged[mP] = array[mid + 1 + rP];
        rP++;
        mP++;

    }

    //Copy back into the original array
    for(int i = 0; i < lMerged; i++){
      array[left + i] = merged[i];
    }

  }
  
  DataPoint[] getSorted(){
    return array;
  }
}

