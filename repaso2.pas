program aseguradora;
const
	totalPolizas=6;
	fin= 1122;

type
	polizas= 1..totalPolizas;
	vector= array [polizas] of real;
	
	cliente= record
		codigoCliente: integer;
		dni: integer;
		apellidoYnombre: string;
		codigoPoliza: polizas;
		montoBasico: real;
	end;

	lista= ^nodo;
	
	nodo=record
		dato: cliente;
		sig: lista;
	end;

//SUBRUTINAS

procedure cargarPrecios (var precios: vector); //SE DISPONE

procedure leer (var c: cliente);
begin
	write ('Ingrese :'); readln (c.codigoCliente);
	write ('Ingrese :'); readln (c.dni);
	write ('Ingrese :'); readln (c.apellidoYnombre);
	write ('Ingrese :'); readln (c.codigoPoliza);
	write ('Ingrese :'); readln (c.montoBasico);
end;

procedure cargarLista (var l: lista);
var
	c: cliente;
	n: lista;
begin
	l:= nil;
	repeat
		leer(c);
		new (n);
		n^.dato:= c;
		n^.sig:= l;
		l:= n;
	until (c.codigoCliente = fin);
end;

procedure descomponer (c: cliente);
var
	digito, cant, numero: integer;
begin 
	cant:= 0;
	numero:= c.codigoCliente;
	while (numero <> 0) or (cant<2) do begin
		digito:= numero mod 10;
		if digito=9 then
			cant:= cant +1;
		numero:= numero div 10;
	end;
	if cant=2 then
		writeln (c.apellidoYnombre, ' tiene al menos mas de dos digitos 9.');
end;


procedure procesar (l: lista; v: vector);
var
	c: cliente;
begin
	while l<>nil do begin
		c:= l^.dato;
		writeln (c.dni, ' ', c.apellidoYnombre, ' Monto total a pagar: $', (c.montoBasico + v[c.codigoPoliza]):0:2);
		descomponer(c);		
		l:= l^.sig;
	end;
end;

procedure eliminar (var l: lista; codigo: integer);
var
	act, ant: lista;
	ok: boolean;
begin
	ok:= false;
	act:= l; ant:= act;
	while (l<>nil) and (l^.dato.codigoCliente <> codigo) do 
	begin
		ant:= act; act:= act^.sig;
	end;
	if act<>nil then 
	begin
		if codigo = act^.dato.codigoCliente then 
		begin
			if act=ant then
				l:= act^.sig
			else
				ant^.sig:= act^.sig;	
			dispose (act);
			ok:= true;
		end;
	end;
		//Lo agrego solo para verificar
	if ok then		
		writeln ('Se elimino cliente codigo: ', codigo)
	else
		writeln ('No se encontro en la lista cliente codigo: ', codigo);			
end;
var		//PROGRAMA PRINCIPAL
	L: lista;
	codigo: integer;
	precio: vector;
begin
	cargarPrecios(precio);
	cargarLista(L);
	procesar(L, precio);
	write('Ingrese codigo de cliente a eliminar: ');
	readln(codigo);
	eliminar(L,codigo);
end.
