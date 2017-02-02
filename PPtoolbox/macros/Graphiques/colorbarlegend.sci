function colorbarlegend(text)
  // Ajoute une légende à une colorbar
  // Description
  // La colorbar doit être appelé juste avant colorbar legend
  
  f = gcf()
  f.children(1).y_label.text=text;
endfunction
