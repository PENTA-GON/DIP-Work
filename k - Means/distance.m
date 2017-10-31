function [ distance ] = distance(object1,object2 )
%calculate the distance between two objects using eucidean distance

results = (object1-object2).^2;
distance = sum(results);

end



