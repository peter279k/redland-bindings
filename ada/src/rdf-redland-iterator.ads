with RDF.Auxiliary.Limited_Handled_Record;

package RDF.Redland.Iterator is

   package Iterator_Handled_Record is new RDF.Auxiliary.Limited_Handled_Record(RDF.Auxiliary.Dummy_Record, RDF.Auxiliary.Dummy_Record_Access);

   type Iterator_Type_Without_Finalize is new Iterator_Handled_Record.Base_Object with null record;

   subtype Iterator_Handle is Iterator_Handled_Record.Access_Type;

   -- TODO: librdf_iterator_map_handler, librdf_iterator_map_free_context_handler,
   -- librdf_new_iterator() are unimplemented

   type Iterator_Type is new Iterator_Type_Without_Finalize with null record;

   overriding procedure Finalize_Handle (Object: Iterator_Type; Handle: Iterator_Handle);

   -- Stopped at librdf_iterator_end()

end RDF.Redland.Iterator;
