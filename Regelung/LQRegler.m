function [K, poleRK] = LQRegler(sys, ric)

Q = ric.Q;
R = ric.R;

if ~issymmetric(Q)
	error('Q ist nicht symmetrisch!')
end

if any(eig(Q)<=0)
	error('Q ist nicht positiv definit!')
end

if any(eig(R)<=0)
	error('R ist nicht positiv definit!')
end

[K, ~, poleRK] = lqr(sys.A, sys.B, Q, R);

end