static class Utils {

  static <T extends Comparable<T>> void sort(T[] arr) {
    // array to arraylist
    ArrayList<T> list = new ArrayList<T>(arr.length);
    for (T t : arr) list.add(t);
    sort(list);
  }

  static <T extends Comparable<T>> void sort(ArrayList<T> list) {
    mergesort(list, 0, list.size() - 1);
  }

  static <T extends Comparable<T>> void mergesort(ArrayList<T> list, int lo, int hi) {
    if (lo < hi) {
      int mid = (lo + hi) / 2;
      mergesort(list, lo, mid);
      mergesort(list, mid + 1, hi);

      ArrayList<T> temp = new ArrayList<T>(list);
      int i = lo, j = mid + 1, k = lo;
      while (i<=mid && j<=hi) {
        if (temp.get(i).compareTo(temp.get(j)) < 0) {
          list.set(k++, temp.get(i++));
        } else {
          list.set(k++, temp.get(j++));
        }
      }
      while (i<=mid) {
        list.set(k++, temp.get(i++));
      } 
      while (j<=hi) {
        list.set(k++, temp.get(j++));
      }
    }
  }
  
}