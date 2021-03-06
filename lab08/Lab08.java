//Konstantinos Papakostas 2399
import java.io.File;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.*;
import java.util.Collection;

class Cache {
	// --------------------------------------------
	// This was not in lab07. Don't remove it !!!!!!!!
	private String writeAllocPolicy;
	// --------------------------------------------

	private int  blockSize;
	private int  associativity;
	private long capacity;

	// -----------------------------------------------------------
	// In addition to your code from lab07,
	// ADD ANY OTHER VARIABLES NEEDED FOR CACHE CONFIGURATION HERE
	// - add structures for your cache (tag storage, valid bits, etc)
	// -----------------------------------------------------------

	// -----------------------------------------------------------
	// Event counters (read/write hits, misses, etc)
	private long readHits;
	private long writeHits;
	private long readMisses;
	private long writeMisses;
	private long numRefills;   // Data transfers from main mem, due to misses
	private long numAccesses;
	private long blockBit;
	private long numSets;
	private long indexBit;
	
	HashMap LRU=null;		//it keeps the addresses and the if someone has been used recently
	HashMap validBit=null;		//it keeps the validBits of the lines
	
	// Initialize any data structures for the cache
	//  and counters of events.
	private void initCache() {
		// --------------------------------------------------------------------
		// Initialize your cache data structures here
		// --------------------------------------------------------------------

		// Clear event counters
		readHits = 0;
		writeHits = 0;
		readMisses = 0;
		writeMisses = 0;
		numRefills = 0;
		numAccesses = 0;
	}
	
	// The main cache method. 
	// process operation op (R-ead, W-rite) at address addr
	//    update cache structures and update event counters
    public void access(String op, long addr) {
	    // -----------------------------------------------------------
		// Write your code here
	    // -----------------------------------------------------------
		long address=getTag(addr);
		long addrindex=getIndex(addr);
		int lru;
		Collection c;
		Object maxValue;
		numAccesses+=1;
		int vb;
		
		Set ref = LRU.keySet();
		Iterator it = ref.iterator();
		List list = new ArrayList();

		
		if(op.equals("W")){
			if(LRU.containsKey(address)==true){
				if((((int)validBit.get(address))&address)==1){
					writeHits++;
					if(LRU.size()==numSets){								//if there is a valid address in cache(valid bit 1)
																		// and the cache is full free the LRU line
						c=LRU.values();									//and add this address
						maxValue=(Object)Collections.max(c);
						
						while (it.hasNext()) {
							Object o = it.next(); 
							if(LRU.get(o).equals(maxValue)) { 
								LRU.remove(o);
								validBit.remove(o);
								break;
							} 
						}		
						validBit.put(address,1);
						LRU.put(address,50);
					}
					else{
						if(getWriteAllocPolicy().equals("A")){
							writeMisses++;
							numRefills++;
							validBit.put(address,1);
							lru=(int)LRU.get(address);
							LRU.put(address,lru-2);	
						}else{
							writeMisses++;
							validBit.put(address,1);
							lru=(int)LRU.get(address);
							LRU.put(address,lru-2);				//it shows which line is the least recently used
						}
					}
				}else{
					numRefills++;
					writeHits++;
				}
			}
			else{	
				numRefills++;
				writeMisses++;									//if the address doesn't exist in cache
				LRU.put(address,50);					//then add it and increase te miss rate
				validBit.put(address,1);
			}
		}else{													// we read now
			if(LRU.containsKey(address)==true){
				if(((int)validBit.get(address)&address)==1){
					readHits++;
					lru=(int)LRU.get(address);
					LRU.put(address,lru-2);
				}else{
					numRefills++;
					readMisses++;
				}
			}else{
				numRefills++;
				readMisses++;
			}
		}
	}

    public void report() {
		System.out.printf("Total Accesses: %d\n", numAccesses);
		System.out.printf("Read hits: %d\n", readHits);
		System.out.printf("Write hits: %d\n", writeHits);
		System.out.printf("Read misses: %d\n", readMisses);
		System.out.printf("Write misses: %d\n", writeMisses);
		System.out.printf("Number of cache refils: %d\n", numRefills);
		System.out.printf("Miss rate: %f\n", (double) (readMisses + writeMisses)/numAccesses);
	}

	public String getWriteAllocPolicy(){
		return writeAllocPolicy;
	}
	// Constructor
	public Cache(String[] args) {

        if (args.length < 4) {
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
		// --------------------------------------------
		// THIS WAS NOT IN LAB07. DON'T REMOVE IT !!!!!!!!
		// --------------------------------------------
        writeAllocPolicy = args[3];
		
        
	    // -----------------------------------------------------------
		// Replace with your code from lab07
		//  --- 
		// Don't forget to call InitCache() below!!!!
		// -----------------------------------------------------------
		blockBit = (int) (Math.log(blockSize) / Math.log(2.0));
		numSets = capacity / blockSize / associativity;
		indexBit = blockBit + (int) (Math.log(numSets) / Math.log(2.0));
		
		validBit=new HashMap((int)numSets);
		LRU=new HashMap((int)numSets);
		initCache();
	}

    public long getTag(long addr) {
	    // -----------------------------------------------------------
		// Replace with your code from lab07
	    // -----------------------------------------------------------
		
		return (addr >>> indexBit);
	}

    public long getIndex(long addr) {
	    // -----------------------------------------------------------
		// Replace with your code from lab07
	    // -----------------------------------------------------------
		return (addr >>> blockBit)&(numSets-1);
	}

    public long getBoff(long addr) {
	    // -----------------------------------------------------------
		// Replace with your code from lab07
	    // -----------------------------------------------------------
		return (addr & (blockSize-1));
	}

}

class Lab08 {

    public static void main(String[] args) throws IOException {
		// Create and initialise a cache
		Cache cache = new Cache(args);

	    String fileName = args[4];
	    File f = new File(fileName);
        if (!f.exists() || f.isDirectory()) { 
            System.err.println("Argument" + args[4] + " must be a file.");
            System.exit(1);
        }

		long lineNo = 1;
	    Pattern p = Pattern.compile("([RW]) ([0-9a-fA-F]+)");
	    try (BufferedReader br = new BufferedReader(new FileReader(f))) {
            for(String line; (line = br.readLine()) != null; ) {
                // Parse the line to get operation type and address
				Matcher m = p.matcher(line);
				if (!m.matches()) {
                    System.err.println("ERROR: Trace file problem at line " + Long.toString(lineNo));
                    System.exit(1);
				}
                String op = m.group(1);
                long addr = Long.parseLong(m.group(2), 16);

				// process the operation type, address
				cache.access(op, addr);
            }
        }
		// Print out the results
		cache.report();
	}
}
