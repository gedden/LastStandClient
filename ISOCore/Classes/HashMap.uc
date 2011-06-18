/**
 * A very simple key/object static sized hash map
 * 
 **/

class HashMap extends Object;

// Member variables
var private int table_size;
var private int count; // populated size
var private Array<HashMapEntry> table;

/**
 * Create a hashmap. Since this does not resize
 * automatically, the programmer must pick a resonable
 * starting size
 **/
public static function HashMap Create(int size)
{
	local HashMap area;

	area = new class'HashMap';
	// Setup the size
	area.table.Add(size);
	area.table_size=size;

	return area;
}

/**
 * Check to see if this hashtable
 * contains an item.
 * 
 * This is just as expencive as Get()
 **/
public function bool Contains(int key)
{
	return Get(key)!=None;
}

/**
 * Get an item from the hashtable
 **/
public function Object Get(const int key)
{
	local HashMapEntry entry;
	local int hash;	

	hash = (key % TABLE_SIZE);

	// sanity check
	if( table[hash] == none ) return None;

	// Go down the chain
	entry = table[hash];

	while( entry != none )
	{
		if( entry.key == key ) return entry.value;
		entry = entry.next;
	}
	return None;
}
 
/**
 * Place an object in the hashtable 
 * with the provided key
 **/
public function Put(const int key, const out Object value)
{
	local int hash;
	local HashMapEntry entry;
	local HashMapEntry current;

	if( value == none )
	{
		Remove(key);
	}

	entry       = new class'HashMapEntry';
	entry.key   = key;
	entry.value = value;
	entry.next  = none;

	hash = (key % TABLE_SIZE);

	if( table[hash] == none )
		table[hash] = entry;
	else
	{
		// Go down the chain
		current = table[hash];

		while( current.next != none )
			current = current.next;
		current.next = entry;
	}
	count++;
}

/**
 * Remove an item from the
 * hashtable
 **/
public function Remove(int key)
{
	local HashMapEntry prev;
	local HashMapEntry entry;
	local int hash;	

	hash = (key % TABLE_SIZE);

	// sanity check, its already gone
	if( table[hash] == none ) return;

	// Go down the chain
	entry = table[hash];
	prev  = none;

	// Go down the chain
	while( entry != none )
	{
		if( entry.key == key )
		{
			if( prev == none )
				table[hash] = entry.next;   // Pop the top of the chain
			else
				prev.next = entry.next;     // vaporize the current entry
			count--;
			return;
		}
		prev  = entry;
		entry = entry.next;

	}
	return;
}

DefaultProperties
{
	table_size = 128;
}
