module rdf.redland.model;

import std.typecons;
import std.string;
import rdf.auxiliary.handled_record;
import rdf.redland.world;
import rdf.redland.node;
import rdf.redland.statement;
import rdf.redland.stream;

struct ModelHandle;

private extern extern(C) {
    void librdf_free_model(ModelHandle* model);
    int librdf_model_enumerate(RedlandWorldHandle* world,
                               const int counter,
                               const char **name,
                               const char **label);
    int librdf_model_size(ModelHandle* model);
    int librdf_model_add(ModelHandle* model,
                         NodeHandle* subject,
                         NodeHandle* predicate,
                         NodeHandle* object);
    int librdf_model_add_statement(ModelHandle* model, StatementHandle* statement);
    int librdf_model_add_statements(ModelHandle* model, StreamHandle* statement_stream);
    int librdf_model_context_add_statement(ModelHandle* model,
                                           NodeHandle* context,
                                           StatementHandle* statement);
int librdf_model_context_add_statements(ModelHandle* model,
                                        NodeHandle* context,
                                        StreamHandle* stream);
}

struct ModelInfo {
    string name, label;
}

struct ModelWithoutFinalize {
    mixin WithoutFinalize!(ModelHandle,
                           ModelWithoutFinalize,
                           Model);
    size_t sizeWithoutException() {
        return librdf_model_size(handle);
    }
    size_t size() {
        size_t res = sizeWithoutException();
        if(res < 0) throw new RDFException();
        return res;
    }
    void add(NodeWithoutFinalize subject,
             NodeWithoutFinalize predicate,
             NodeWithoutFinalize object)
    {
        if(librdf_model_add(handle, subject.handle, predicate.handle, object.handle) != 0)
            throw new RDFException();
    }
    void add(StatementWithoutFinalize statement,
             NodeWithoutFinalize context = NodeWithoutFinalize.fromHandle(null))
        in(statement.isComplete)
    {
        if(librdf_model_context_add_statement(handle, context.handle, statement.handle) != 0)
            throw new RDFException();
    }
    void add(StreamWithoutFinalize statements,
             NodeWithoutFinalize context = NodeWithoutFinalize.fromHandle(null))
    {
        if(librdf_model_context_add_statements(handle, context.handle, statements.handle) != 0)
            throw new RDFException();
    }
}

struct Model {
    mixin WithFinalize!(ModelHandle,
                        ModelWithoutFinalize,
                        Model,
                        librdf_free_model);
}

Nullable!ModelInfo enumerateModels(RedlandWorldWithoutFinalize world, uint counter) {
    char* name, label;
    int Result = librdf_model_enumerate(world.handle, counter, &name, &label);
    return Nullable!ModelInfo(ModelInfo(name.fromStringz.idup, label.fromStringz.idup));
}

struct ModelsEnumerate {
private:
    RedlandWorldWithoutFinalize _world;
    uint counter = 0;
public:
    @property bool empty() {
        return librdf_model_enumerate(_world.handle, counter, null, null) != 0;
    }
    @property ModelInfo front()
        in(!empty)
    {
        return enumerateModels(_world, counter);
    }
    void popFront()
        in(!empty)
    {
        ++counter;
    }
}

// TODO: Stopped at Remove

