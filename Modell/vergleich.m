sys = SchlittenPendel
DP = getDPendulumF
dpf=subs(DP.f,str2sym({'x1','x2','x3','x4','x5','x6'}),str2sym({'x0', 'x0_p','phi1','phi1_p', 'phi2', 'phi2_p'}))
 dpf-sys.f
 simplify(ans)
 