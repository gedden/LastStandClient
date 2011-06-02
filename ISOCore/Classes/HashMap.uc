class HashMap extends Object;

// Unfinished, base on http://www.algolist.net/Data_structures/Hash_table

const DEFAULT_TABLE_SIZE = 128;

var private float   threshold;
var private int     maxSize;
var private int     size;

/*
struct HashEntry
{
	var int key;
	var int value;
};
*/

var private array<HashEntry> table;

 
function initialize()
{
	table.Add(DEFAULT_TABLE_SIZE);
}
 

function setThreshold(float thresh)
{
	threshold   = thresh;
	maxSize     = table.length * threshold;
}

/*
function int get(int key)
{
	local int hash;
	local int initialHash;

	initialHash = -1;
	hash        = (key % table.length);

	while (hash != initialHash && (table[hash] == DeletedEntry.getUniqueDeletedEntry() || table[hash] != null

                        && table[hash].getKey() != key)) {

                  if (initialHash == -1)

                        initialHash = hash;

                  hash = (hash + 1) % table.length;

            }

            if (table[hash] == null || hash == initialHash)

                  return -1;

            else

                  return table[hash].getValue();

      }

 

      public void put(int key, int value) {

            int hash = (key % table.length);

            int initialHash = -1;

            int indexOfDeletedEntry = -1;

            while (hash != initialHash

                        && (table[hash] == DeletedEntry.getUniqueDeletedEntry()

                        || table[hash] != null

                        && table[hash].getKey() != key)) {

                  if (initialHash == -1)

                        initialHash = hash;

                  if (table[hash] == DeletedEntry.getUniqueDeletedEntry())

                        indexOfDeletedEntry = hash;

                  hash = (hash + 1) % table.length;

            }

            if ((table[hash] == null || hash == initialHash)

                        && indexOfDeletedEntry != -1) {

                  table[indexOfDeletedEntry] = new HashEntry(key, value);

                  size++;

            } else if (initialHash != hash)

                  if (table[hash] != DeletedEntry.getUniqueDeletedEntry()

                             && table[hash] != null && table[hash].getKey() == key)

                        table[hash].setValue(value);

                  else {

                        table[hash] = new HashEntry(key, value);

                        size++;

                  }

            if (size >= maxSize)

                  resize();

      }

 

      private void resize() {

            int tableSize = 2 * table.length;

            maxSize = (int) (tableSize * threshold);

            HashEntry[] oldTable = table;

            table = new HashEntry[tableSize];

            size = 0;

            for (int i = 0; i < oldTable.length; i++)

                  if (oldTable[i] != null

                             && oldTable[i] != DeletedEntry.getUniqueDeletedEntry())

                        put(oldTable[i].getKey(), oldTable[i].getValue());

      }

 

      public void remove(int key) {

            int hash = (key % table.length);

            int initialHash = -1;

            while (hash != initialHash

                        && (table[hash] == DeletedEntry.getUniqueDeletedEntry()

                        || table[hash] != null

                        && table[hash].getKey() != key)) {

                  if (initialHash == -1)

                        initialHash = hash;

                  hash = (hash + 1) % table.length;

            }

            if (hash != initialHash && table[hash] != null) {

                  table[hash] = DeletedEntry.getUniqueDeletedEntry();

                  size--;

            }

      }

}
*/
DefaultProperties
{
	threshold   = 0.75f;
	maxSize     = 96;
	size        = 0;
}
