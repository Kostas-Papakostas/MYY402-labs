// ----------------------------------------------------------------------------
// MYY-402 Computer Architecture
//  cse.uoi.gr
// ----------------------------------------------------------------------------
import java.io.File;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.lang.Math;

class Cache {
	private int  blockSize; //each block has blocksize bytes
	private int  associativity;
	private long capacity;
	private int numofset;
	private int power=0;//power of 2 for blocksize;
	private int addrsize=48;//zize of address
	private int blockoff;
	private double setindex;
	
	// -----------------------------------------------------------
	// ADD ANY OTHER VARIABLES NEEDED FOR CACHE CONFIGURATION HERE
	// E.G.:
	// private long numSets;
	// -----------------------------------------------------------


	// Constructor
	public Cache(String[] args) {

        if (args.length < 3) {
            System.err.println("ERROR: Configuration info not provided. Exiting.");
            System.exit(1);
        }
        try {
            blockSize = Integer.parseInt(args[0]);
        } catch (NumberFormatException e) {
            System.err.println("Argument" + args[0] + " must be an integer.");
            System.exit(1);
        }
        try {
            associativity = Integer.parseInt(args[1]);
        } catch (NumberFormatException e) {
            System.err.println("Argument" + args[1] + " must be an integer.");
            System.exit(1);
        }
        try {
            capacity = Integer.parseInt(args[2]);
        } catch (NumberFormatException e) {
            System.err.println("Argument" + args[2] + " must be an integer.");
            System.exit(1);
        }
		//################NEW CODE#######################
		numofset=8/associativity; //computes the number of sets
		blockoff=addrsize % (4*(int)Math.pow(2,(Math.log(blockSize)/Math.log(2))));
		setindex=Math.log(numofset)/Math.log(2);
	    // -----------------------------------------------------------
		// Complete code here for other cache parameters derived from the above.
	    // -----------------------------------------------------------
	}

    public long getTag(long addr) {
	    // -----------------------------------------------------------
		// Write code here
		// Replace return const below with the computed tag
	    // -----------------------------------------------------------
		int mask;
		long res;
		mask=addrsize-((int)setindex*4)-((int)(Math.log(blockSize)/Math.log(2))*4);
		res=addr >> mask;
		
		return res;
	}

    public long getIndex(long addr) {
	    // -----------------------------------------------------------
		// Write code here
		// Replace return const below with the computed index
	    // -----------------------------------------------------------
		long res;
		res=addr >>> ((int)setindex*4);
		res=res % ((int)setindex*4);
		return res;
	}
    public long getBoff(long addr) {
	    // -----------------------------------------------------------
		// Write code here
		// Replace return const below with the computed block offset
	    // -----------------------------------------------------------
		long res;
		res=addr & (blockoff);
		return res;
	}

}

class Lab07 {

    public static void main(String[] args) throws IOException {
        Cache cache = new Cache(args);

	    String fileName = args[3];
	    File f = new File(fileName);
        if (!f.exists() || f.isDirectory()) { 
            System.err.println("Argument" + args[3] + " must be a file.");
            System.exit(1);
        }

	    try (BufferedReader br = new BufferedReader(new FileReader(f))) {
            for(String line; (line = br.readLine()) != null; ) {
                // process the line.
		        long addr = Long.parseLong(line, 16);

			    long tag = cache.getTag(addr);
			    long idx = cache.getIndex(addr);
			    long boff = cache.getBoff(addr);
			    System.out.printf("Address: %x => Tag: %x, Index: %x, Boff: %x\n", addr, tag, idx, boff);
            }
        }
	}
}
