class HashMapISOPathNode extends Object;

var HashArea hash;
var array<ISOPathNode> list;

public function setup(int size)
{
	// Setup the hash table
	hash = class'HashArea'.static.Create(size);
}

public function bool Contains(ISOPathNode node)
{
	return hash.Contains(node.GetIndex());
}

public function bool ContainsKey(int key)
{
	return hash.Contains(key);
}

public function ISOPathNode Get(int key)
{
	local int index;
	
	index = hash.Get(key);

	// I got nothing!
	if( index == INDEX_NONE ) return none;

	return list[index];
}
 

public function Put(int key, ISOPathNode node)
{
	list.AddItem(node);
	hash.Put(key, list.Length-1);
}

/**
 * When I have time to write an actual hashtable, I will. 
 * 
 * Right now, this is just going to be a linear lookup
 **/

/*
var int table_size;

var array<ISOPathNode> table;

public function bool Contains(ISOPathNode node)
{
	return table.Find(node)>0;
}

public function bool ContainsKey(int key)
{
	local ISOPathNode pnode;
	foreach table(pnode)
	{
		if( pnode.GetIndex() == key )
			return true;
	}
	return false;
}

public function ISOPathNode Get(int key)
{
	local ISOPathNode pnode;

	foreach table(pnode)
	{
		if( pnode.GetIndex() == key )
			return pnode;
	}
	return none;
}
 

public function Put(int key, ISOPathNode node)
{
	table.AddItem(node);
}
*/
