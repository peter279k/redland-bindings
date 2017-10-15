package body RDF.Auxiliary.Handled_Record is

   procedure Set_Handle_Hack(Object: in out Base_Object; Handle: Access_Type) is
   begin
      Object.Handle := Handle;
   end;

   function Get_Handle(Object: Base_Object) return Access_Type is (Object.Handle);

   function From_Handle(Handle: Access_Type) return Base_Object is
     (Ada.Finalization.Controlled with Handle=>Handle);

   function From_Non_Null_Handle(Handle: Access_Type) return Base_Object is
   begin
      if Handle = null then
         raise Null_Handle;
      end if;
      return From_Handle(Handle);
   end;

   function Default_Handle(Object: Base_Object) return Access_Type is (null);

   procedure Initialize (Object: in out Base_Object) is
   begin
      Object.Handle := Default_Handle(Base_Object'Class(Object));
   end Initialize;

   procedure Finalize (Object : in out Base_Object) is
   begin
      if Object.Handle /= null then
         Finalize_Handle(Base_Object'Class(Object), Object.Handle);
         Object.Handle := null;
      end if;
   end Finalize;

   procedure Adjust(Object: in out Base_Object) is
   begin
      if Object.Handle /= null then
         Object.Handle := Adjust_Handle(Base_Object'Class(Object), Object.Handle);
      end if;
   end;

   function Adjust_Handle(Object: Base_Object; Handle: Access_Type) return Access_Type is
   begin
      return Handle; -- default for _Without_Finalize
   end;

   function Is_Null (Object: Base_Object) return Boolean is
   begin
      return Object.Handle = null;
   end;

   function Copy(Object: Base_Object) return Base_Object is
   begin
      return From_Handle(Adjust_Handle(Object, Get_Handle(Object)));
   end;

end RDF.Auxiliary.Handled_Record;
