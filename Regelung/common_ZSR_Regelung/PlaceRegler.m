function K = PlaceRegler(sys, pole)
    K = place(sys.A, sys.B, pole);
end