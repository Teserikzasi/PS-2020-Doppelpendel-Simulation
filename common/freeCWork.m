function freeCWork(id)

    global g_CWork;
    
    g_CWork{id} = [];
    
    vAllocatedIDs = g_CWork{1};
    
    vAllocatedIDs = vAllocatedIDs(vAllocatedIDs ~= id);
    
    maxAllocatedID = max(vAllocatedIDs);
    if isempty(maxAllocatedID)
        maxAllocatedID = 0;
    end
    
    maxID = length(g_CWork);

    g_CWork((maxAllocatedID+1):maxID) = [];
    
    g_CWork{1} = vAllocatedIDs;
    
    if isempty(vAllocatedIDs)
        clear global g_CWork;
    end

end