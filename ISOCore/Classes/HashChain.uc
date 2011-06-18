/**
 * This is basically a very simple STATIC SIZE hashmap.
 * 
 * It is a little different than the HashArea, in that this hashtable
 * is better at datasets for larger collisions
 * 
 **/

class HashChain extends Object implements(HashInterface);

var int table_size;
var int count; // populated size
var array<HashEntryChain> table;

public static function HashChain Create(int size)
{
	local HashChain area;

	area = new class'HashChain';
	// Setup the size
	area.table.Add(size);
	area.table_size=size;

	return area;
}

public function bool Contains(int key)
{
	return Get(key)!=INDEX_NONE;
}

public function int Get(int key)
{
	local HashEntryChain entry;
	local int hash;	

	hash = (key % TABLE_SIZE);

	// sanity check
	if( table[hash] == none ) return INDEX_NONE;

	// Go down the chain
	entry = table[hash];

	while( entry != none )
	{
		if( entry.key == key ) return entry.value;
		entry = entry.next;
	}
	return INDEX_NONE;
}
 

public function Put(int key, const int value)
{
	local int hash;
	local HashEntryChain entry;
	local HashEntryChain current;

	if( value == INDEX_NONE )
	{
		Remove(key);
	}

	entry       = new class'HashEntryChain';
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

public function Remove(int key)
{
	local HashEntryChain prev;
	local HashEntryChain entry;
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

public function toLog()
{
	local int hash;
	local HashEntryChain entry;
	local string line;

	for( hash=0; hash<table_size; hash++ )
	{
		if( table[hash] == none )
			`log("Entry :" @hash @table[hash] );
		else
		{
			entry = table[hash];
			line = "";
			while( entry != none )
			{
				line @= entry.value;
				entry = entry.next;
			}
			`log("Entry: " @Line );
		}
	}
}

DefaultProperties
{
	table_size = 128;
}
