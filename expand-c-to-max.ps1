$s = get-partitionsupportedsize -drivel C; resize-partition -drivel C -size $s.SizeMax
