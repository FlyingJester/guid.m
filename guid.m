:- module guid.
:- interface.

:- import_module io.

% A larger but dependable GUID type.
:- type guid.guid.
% Simpler but more naive. Also more performant to generate and compare.
:- type guid.id.

:- type guid.generator.

:- pred guid.create_generator(io::di, io::uo, guid.generator::uo) is det.
:- pred guid.create_generator(int::in, guid.generator::uo) is det.

:- pred guid.generate(guid.generator, guid.generator, guid.guid).
:- mode guid.generate(mdi, muo, uo) is det.
:- mode guid.generate(in, out, out) is det.

:- pred guid.generate_id(guid.generator, guid.generator, guid.id).
:- mode guid.generate_id(mdi, muo, uo) is det.
:- mode guid.generate_id(in, out, out) is det.

% Equality predicate
:- pred guid_equal(guid.guid, guid.guid).
:- mode guid_equal(in, in) is semidet.
:- mode guid_equal(in, out) is det.
:- mode guid_equal(out, in) is det.
:- mode guid_equal(di, uo) is det.
:- mode guid_equal(uo, di) is det.

:- pred id_equal(guid.id, guid.id).
:- mode id_equal(in, in) is semidet.
:- mode id_equal(in, out) is det.
:- mode id_equal(out, in) is det.
:- mode id_equal(di, uo) is det.
:- mode id_equal(uo, di) is det.

:- implementation.

:- import_module int, float, time, random, maybe.

:- type serial == int.
:- type guid ---> guid(int, int, int, int, serial).
:- type id ---> id(serial).

:- type guid.generator ---> generator(random.supply, serial).

guid.create_generator(Seed, generator(RNGS, 0)) :- random.init(Seed, RNGS).
guid.create_generator(!IO, Generator) :-
    time.time(Time, !IO),
    Epoch = tm(70, 0, 0, 0, 0, 0, 0, 0, no),
    create_generator(float.floor_to_int(difftime(mktime(Epoch), Time)), Generator).

guid.generate(generator(SupplyIn, Serial), generator(SupplyOut, Serial+1), GUID) :-
    GUID = guid.guid(RND1+0, RND2+0, RND3+0, RND4+0, Serial+0),
    random.random(RND1, SupplyIn, S1),
    random.random(RND2, S1, S2),
    random.random(RND3, S2, S3),
    random.random(RND4, S3, SupplyOut).

guid.generate_id(generator(RNGS, Serial), generator(RNGS, Serial+1), id(Serial+0)).

guid_equal(guid(A+0, B+0, C+0, D+0, Serial+0), guid(A+0, B+0, C+0, D+0, Serial+0)).
id_equal(id(Serial+0), id(Serial+0)).

