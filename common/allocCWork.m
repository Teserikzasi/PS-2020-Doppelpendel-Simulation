function id = allocCWork()

    global g_CWork;
    
    if ( isempty(g_CWork) || isempty(g_CWork{1}) )
        vAllocatedIDs = [];
        id = 2;
    else
        vAllocatedIDs = g_CWork{1};
        vAllocatedIDs = sort(vAllocatedIDs);

        id = find(vAllocatedIDs ~= (2:length(vAllocatedIDs)+1), 1);

        if ~isempty(id)
            id = id + 1;
        else
            id = length(g_CWork) + 1;
        end
    end
        
    g_CWork{id} = {};
    
    
    vAllocatedIDs = sort([vAllocatedIDs id]);
    g_CWork{1} = vAllocatedIDs;

end