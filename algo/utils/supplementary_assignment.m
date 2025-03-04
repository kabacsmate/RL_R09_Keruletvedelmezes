function [assignment,newAssignment] = supplementary_assignment(defenders,intruders,assignment,nu,perimeter)
newAssignment = [];
unassignedDefenders = find(assignment(1:length(defenders))==0);
unassignedIntruders = 1:size(intruders,1);
unassignedIntruders = unassignedIntruders(~ismember(unassignedIntruders,assignment));
if ~isempty(unassignedDefenders) && ~isempty(unassignedIntruders) 
    for u=1:length(unassignedDefenders)
        d = unassignedDefenders(u);
        sD = defenders(d).l;
        J = zeros(size(unassignedIntruders));
        for v=1:length(unassignedIntruders)
            i = unassignedIntruders(v);
            xA = intruders(i).Position;
            [~,J(v)] = isInRD(sD,xA,nu,perimeter);
        end
        [~,idx] = min(J);
        i = unassignedIntruders(idx);
        assignment(d) = i;
        newAssignment(end+1,1:2) = [i,d];
    end
end