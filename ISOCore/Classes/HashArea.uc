/**
 * This is basically a very simple, stupid STATIC SIZE hashmap.
 * It does, however, have very low overhead
 * 
 * Based on http://www.algolist.net/Data_structures/Hash_table/Simple_example
 **/

class HashArea extends Object implements(HashInterface);

var int table_size;
var int count; // populated size
var array<HashEntry> table;

public static function HashArea Create(int size)
{
	local HashArea area;

	area = new class'HashArea';
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
	local int checksum;
	local int hash;
	local int startingHash;
	

	checksum = 0;
	hash = (key % TABLE_SIZE);
	startingHash = hash;

	while (table[hash] != None && table[hash].key != key)
	{
		hash = (hash + 1) % TABLE_SIZE;
		// Sanity check

		checksum++;
		if( hash == startingHash || checksum > count) break;
	}

	if (table[hash] == none)
	{
		//`log("Getting Hash (FAILED): " @key @Hash );
		return INDEX_NONE; // -1 == INDEX_NONE
	}
	else
	{
		//`log("Getting Hash (PASSED): " @key @Hash @table[hash].value );
		return table[hash].value;
	}
}
 

public function Put(int key, const int value)
{
	local int hash;
	local int start;
	local HashEntry entry;

	hash = (key % TABLE_SIZE);
	start= hash;

	while (table[hash] != none && table[hash].key != key)
	{
		hash        = (hash + 1) % TABLE_SIZE;

		if( hash == start )
		{
			`log("  ****** CRITICAL HASHAREA FAILURE! HASH TABLE IS NOT BIG ENOUGH!"  );
			return;
		}
		
	}
	//`log("Adding Hash " @key @hash );
	entry       = new class'HashEntry';
	entry.key   = key;
	entry.value = value;

	table[hash] = entry;
	count++;
}

public function toLog()
{
	local int hash;

	for( hash=0; hash<table_size; hash++ )
	{
		if( table[hash] == none )
			`log("Entry :" @hash @table[hash] );
		else
			`log("Entry :" @hash @table[hash].key @table[hash].value );
	}
}

DefaultProperties
{
	table_size = 128;
}
