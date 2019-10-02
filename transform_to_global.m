function p = transform_to_global(q, R, t,s)
if nargin==3
    s=1;
end

p(1:2,:) = s*R*q(1:2,:);

% translate
p(1,:) = p(1,:) + t(1);
p(2,:) = p(2,:) + t(2);