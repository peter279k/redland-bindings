with Ada.Finalization;

generic
   type Record_Type; -- It should be an untagged record for C compatibility
package RDF.Auxilary.Handled_Record is

   type Access_Type is access Record_Type
      with Convention=>C;

   -- It is logically abstract, but not exactly abstract in Ada sense.
   -- It can't be abstract because the function From_Handle returns this type.
   type Base_Object is new Ada.Finalization.Controlled with private;

   overriding procedure Initialize(Object: in out Base_Object);

   overriding procedure Finalize(Object: in out Base_Object);

--     overriding procedure Adjust(Object: in out Base_Object);

   -- Don't call this procedure unless you really need it.
   not overriding procedure Set_Handle_Hack(Object: in out Base_Object; Handle: Access_Type);

   -- TODO: Should check non-null predicate?
   not overriding function Get_Handle(Object: Base_Object) return Access_Type with Inline;

   not overriding function From_Handle(Handle: Access_Type) return Base_Object with Inline;

   not overriding function Default_Handle(Object: Base_Object) return Access_Type;

   not overriding procedure Finalize_Handle(Object: Base_Object; Handle: Access_Type) is null;

--     not overriding function Copy_Handle(Object: Base_Object; Handle: Access_Type) return Access_Type;

private

   type Base_Object is new Ada.Finalization.Controlled with
      record
         Handle: Access_Type;
      end record;

end RDF.Auxilary.Handled_Record;
