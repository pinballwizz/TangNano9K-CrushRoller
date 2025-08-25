copy /b tpa + tpc + tpb + tpd gfx1.bin
make_vhdl_prom gfx1.bin GFX1.vhd

copy /b tp1 + tp5a + tp2 + tp6 + tp3 + tp7 + tp4 + tp8 main.bin
make_vhdl_prom main.bin ROM_PGM_0.vhd

make_vhdl_prom 82s126.1m PROM1_DST.vhd
make_vhdl_prom 2s140.4a PROM4_DST.vhd
make_vhdl_prom 82s123.7f PROM7_DST.vhd

pause