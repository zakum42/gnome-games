public class JaroWinklerDistance {
    /* The Winkler modification will not be applied unless the
     * percent match was at or above the mWeightThreshold percent
     * without the modification.
     * Winkler's paper used a default value of 0.7
     */
    private static const double mWeightThreshold = 0.7;

    /* Size of the prefix to be concidered by the Winkler modification.
     * Winkler's paper used a default value of 4
     */
    private static const int mNumChars = 4;

    private static int min(int i, int j) {
        if (i < j) return i;
        return j;
    }

    private static int max(int i, int j) {
        if (i < j) return j;
        return i;
    }


    public static double distance(string aString1, string aString2) {
        return proximity(aString1,aString2);
    }


    public static double proximity(string aString1, string aString2)
    {
        int lLen1 = aString1.length;
        int lLen2 = aString2.length;
        if (lLen1 == 0)
            return lLen2 == 0 ? 1.0 : 0.0;

        int  lSearchRange = (int) max(0,max(lLen1,lLen2)/2 - 1);

        // default initialized to false
        bool[] lMatched1 = new bool[lLen1];
        bool[] lMatched2 = new bool[lLen2];

        int lNumCommon = 0;
        for (int i = 0; i < lLen1; ++i) {
            int lStart = (int) max(0,i-lSearchRange);
            int lEnd = (int) min(i+lSearchRange+1,lLen2);
            for (int j = lStart; j < lEnd; ++j) {
                if (lMatched2[j]) continue;
                if (aString1[i] != aString2[j])
                    continue;
                lMatched1[i] = true;
                lMatched2[j] = true;
                ++lNumCommon;
                break;
            }
        }
        if (lNumCommon == 0) return 0.0;

        int lNumHalfTransposed = 0;
        int k = 0;
        for (int i = 0; i < lLen1; ++i) {
            if (!lMatched1[i]) continue;
            while (!lMatched2[k]) ++k;
            if (aString1[i] != aString2[k])
                ++lNumHalfTransposed;
            ++k;
        }
        // stdout.printf("numHalfTransposed=" + numHalfTransposed);
        int lNumTransposed = lNumHalfTransposed/2;

        // stdout.printf("numCommon=" + numCommon + " numTransposed=" + numTransposed);
        double lNumCommonD = lNumCommon;
        double lWeight = (lNumCommonD/lLen1
                         + lNumCommonD/lLen2
                         + (lNumCommon - lNumTransposed)/lNumCommonD)/3.0;

        if (lWeight <= mWeightThreshold) return lWeight;
        int lMax = (int) min(mNumChars,min(aString1.length,aString2.length));
        int lPos = 0;
        while (lPos < lMax && aString1[lPos] == aString2[lPos])
            ++lPos;
        if (lPos == 0) return lWeight;
        return lWeight + 0.1 * lPos * (1.0 - lWeight);
    }
}
