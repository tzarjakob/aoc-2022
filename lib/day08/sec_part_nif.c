#include <erl_nif.h>
#include "sec_part.h"
#include <stdio.h>

static ERL_NIF_TERM sec_part_nif(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
  int result;
  char* BUFFER = (char*) malloc(BUFSIZ * sizeof(char));
  if (!enif_get_string(env, argv[0], BUFFER, BUFSIZ, ERL_NIF_LATIN1))
  {
    return enif_make_badarg(env);
  }
  
  result = second_part(BUFFER);
  free(BUFFER);
  return enif_make_int(env, result);
}

static ErlNifFunc nif_funcs[] = {
    {"part_two_nif", 1, sec_part_nif},
};

ERL_NIF_INIT(Elixir.Day08, nif_funcs, NULL, NULL, NULL, NULL)
