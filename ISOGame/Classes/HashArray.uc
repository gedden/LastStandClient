class HashArray extends Object;

struct HashedArray
{
	var Name Key;
	var Object Object;
};

var array<HashedArray> MyHashedArray;

function Object GetObject(Name Key)
{
	local int Index;

	Index = MyHashedArray.Find('Key', Key);
	if (Index != INDEX_NONE)
	{
		return MyHashedArray[Index].Object;
	}

	return None;
}

function AddObject(Name Key, Object obj)
{
	local HashedArray item;

	item.Key = Key;
	item.Object = obj;

	MyHashedArray.AddItem(item);
}

DefaultProperties
{
}
