function L = PlaceBeobachter(sys, pole)
    L = place(sys.A', sys.C', pole).';
end