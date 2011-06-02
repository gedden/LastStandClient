/**
 * This is basically a very simple, stupid STATIC SIZE hashmap.
 * It does, however, have very low overhead
 * 
 * Based on http://www.algolist.net/Data_structures/Hash_table/Simple_example
 **/

class HashArea extends Object;

var int table_size;

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
	local int hash;
	
	hash = (key % TABLE_SIZE);

	while (table[hash] != none && table[hash].key != key)
		hash = (hash + 1) % TABLE_SIZE;

	return (table[hash] == none);
}

public function int Get(int key)
{
	local int hash;
	
	hash = (key % TABLE_SIZE);

	while (table[hash] != None && table[hash].key != key)
		hash = (hash + 1) % TABLE_SIZE;

	if (table[hash] == none)
		return -1;
	else
		return table[hash].value;
}
 

public function Put(int key, const int value)
{
	local int hash;
	local HashEntry entry;

	hash = (key % TABLE_SIZE);

	while (table[hash] != none && table[hash].key != key)
	{
		hash        = (hash + 1) % TABLE_SIZE;
		entry       = new class'HashEntry';
		entry.key   = key;
		entry.value = value;

		table[hash] = entry;
	}
}

DefaultProperties
{
	table_size = 128;
}
