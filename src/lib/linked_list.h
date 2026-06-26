#ifndef LINKED_LIST
#define LINKED_LIST

    typedef struct NodeInfo
    {
        char* content;
        struct NodeInfo* next;
    }NodeInfo;
    
    typedef struct LinkedList
    {
        NodeInfo* start;
        NodeInfo* end;
        int size;
    }LinkedList;
    
    NodeInfo* CreateNodeInfo(char*);
    LinkedList* CreateLinkedList();
    void PushElement(LinkedList*,NodeInfo*);
    NodeInfo* AcessAt(LinkedList*,int);
#endif
