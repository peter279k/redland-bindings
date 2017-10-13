with Interfaces.C; use Interfaces.C;

package body RDF.Raptor.Statement is

   function Get_World (Statement: Statement_Type_Without_Finalize) return Raptor_World_Type_Without_Finalize is
   begin
      --        return Get_Handle(Statement).World.all; -- does not work, so the below hack:
      return S: Raptor_World_Type_Without_Finalize do
         Set_Handle_Hack(S, Get_Handle(Statement).World);
      end return;
   end;

   function Get_Subject   (Statement: Statement_Type_Without_Finalize) return Term_Type_Without_Finalize is
     (From_Handle(Get_Handle(Statement).Subject));
   function Get_Predicate (Statement: Statement_Type_Without_Finalize) return Term_Type_Without_Finalize is
     (From_Handle(Get_Handle(Statement).Predicate));
   function Get_Object    (Statement: Statement_Type_Without_Finalize) return Term_Type_Without_Finalize is
     (From_Handle(Get_Handle(Statement).Object));
   function Get_Graph     (Statement: Statement_Type_Without_Finalize) return Term_Type_Without_Finalize is
     (From_Handle(Get_Handle(Statement).Graph)); -- may return null handle

   --     function No_Auto_Finalization (Term: Term_Type_Without_Finalize'Class) return Boolean is
   --     begin
   --        return Is_Null(Term) or not (Term in Term_Type'Class);
   --     end;

   function raptor_new_statement (World: Raptor_World_Handle) return Statement_Handle
     with Import, Convention=>C;

   function New_Statement (World: Raptor_World_Type_Without_Finalize'Class) return Statement_Type is
   begin
      return From_Non_Null_Handle( raptor_new_statement(Get_Handle(World)) );
   end;

   function raptor_new_statement_from_nodes (World: Raptor_World_Handle;
                                             Subject, Predicate, Object, Graph: Term_Handle)
                                             return Statement_Handle
     with Import, Convention=>C;

   function New_Statement (World: Raptor_World_Type_Without_Finalize'Class;
                           Subject, Predicate, Object: Term_Type_Without_Finalize'Class;
                           Graph: Term_Type_Without_Finalize'Class := Term_Type_Without_Finalize'(From_Handle(null)))
                           return Statement_Type is
   begin
      return New_Statement_Without_Copies(World,
                                          Term_Type_Without_Finalize'(Copy(Subject)),
                                          Term_Type_Without_Finalize'(Copy(Predicate)),
                                          Term_Type_Without_Finalize'(Copy(Object)),
                                          Term_Type_Without_Finalize'(Copy(Graph)));
   end;

   function New_Statement_Without_Copies (World: Raptor_World_Type_Without_Finalize'Class;
                                          Subject, Predicate, Object: Term_Type_Without_Finalize'Class;
                                          Graph: Term_Type_Without_Finalize'Class := Term_Type_Without_Finalize'(From_Handle(null)))
                                          return Statement_Type is
   begin
      return From_Non_Null_Handle( raptor_new_statement_from_nodes(Get_Handle(World),
                                   Get_Handle(Subject), Get_Handle(Predicate), Get_Handle(Object), Get_Handle(Graph)) );
   end;

   procedure raptor_free_statement (Statement: Statement_Handle)
     with Import, Convention=>C;

   procedure Finalize_Handle (Object: Statement_Type; Handle: Statement_Handle) is
   begin
      raptor_free_statement(Handle);
   end;

   function raptor_statement_copy (Term: Statement_Handle) return Statement_Handle
     with Import, Convention=>C;

   function Adjust_Handle (Object: Statement_Type; Handle: Statement_Handle) return Statement_Handle is
   begin
      return raptor_statement_copy(Handle);
   end;

   function Copy (Object: Statement_Type_Without_Finalize'Class)
                  return Statement_Type_Without_Finalize is
   begin
      return From_Handle (raptor_statement_copy (Get_Handle(Object)) );
   end;

   function raptor_statement_compare (Left, Right: Statement_Handle) return int
     with Import, Convention=>C;

   function Compare (Left, Right: Statement_Type_Without_Finalize) return RDF.Auxiliary.Comparison_Result is
   begin
      return RDF.Auxiliary.Sign( raptor_statement_compare(Get_Handle(Left), Get_Handle(Right)) );
   end;

   function raptor_statement_equals (Left, Right: Statement_Handle) return int
     with Import, Convention=>C;

   function Equals (Left, Right: Statement_Type_Without_Finalize) return Boolean is
   begin
      return raptor_statement_equals(Get_Handle(Left), Get_Handle(Right)) /= 0;
   end;

   function raptor_statement_print (Statement: Statement_Handle; File: RDF.Auxiliary.C_File_Access)
                                    return int
     with Import, Convention=>C;

   procedure Print (Statement: Statement_Type_Without_Finalize; File: RDF.Auxiliary.C_File_Access) is
   begin
      if raptor_statement_print(Get_Handle(Statement), File) /= 0 then
         raise IOStream_Exception;
      end if;
   end;

   function raptor_statement_print_as_ntriples (Statement: Statement_Handle; File: RDF.Auxiliary.C_File_Access)
                                                return int
     with Import, Convention=>C;

   procedure Print_As_Ntriples (Statement: Statement_Type_Without_Finalize; File: RDF.Auxiliary.C_File_Access) is
   begin
      if raptor_statement_print_as_ntriples(Get_Handle(Statement), File) /= 0 then
         raise IOStream_Exception;
      end if;
   end;

   function raptor_statement_ntriples_write (Statement: Statement_Handle;
                                             Stream: IOStream_Handle;
                                             Write_Graph_Term: int)
                                             return Int
     with Import, Convention=>C;

   procedure Ntriples_Write (Statement: Statement_Type_Without_Finalize;
                             Stream: Base_Stream_Type'Class;
                             Write_Graph_Term: Boolean) is
      Flag: constant int := (if Write_Graph_Term then 1 else 0);
   begin
      if raptor_statement_ntriples_write(Get_Handle(Statement), Get_Handle(Stream), Flag) /= 0 then
         raise IOStream_Exception;
      end if;
   end;

end RDF.Raptor.Statement;
