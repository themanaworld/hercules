// Copyright (c) Hercules Dev Team, licensed under GNU GPL.
// See the LICENSE file
// Base author: Haru <haru@dotalux.com>

#ifndef COMMON_HERCULES_H
#define COMMON_HERCULES_H

#include "config/core.h"
#include "common/cbasetypes.h"

#ifdef WIN32
	#define HPExport __declspec(dllexport)
#else
	#define HPExport __attribute__((visibility("default")))
#endif

#ifdef HERCULES_CORE
#define HPShared extern
#else // !HERCULES_CORE
#define HPShared HPExport
#include "common/HPMi.h"
#endif // HERCULES_CORE

#endif // COMMON_HERCULES_H
