# -*-makefile-*-
#
# Copyright (C) 2010 by Jon Ringle
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_HOST_CT_NG) += host-ct-ng

#
# Paths and names
#
HOST_CT_NG_VERSION	:= $(call remove_quotes,$(PTXCONF_HOST_CT_NG_VERSION))
HOST_CT_NG		:= crosstool-ng-$(HOST_CT_NG_VERSION)
HOST_CT_NG_SUFFIX	:= tar.bz2
HOST_CT_NG_URL	:= http://ymorin.is-a-geek.org/download/crosstool-ng/$(HOST_CT_NG).$(HOST_CT_NG_SUFFIX)
HOST_CT_NG_SOURCE	:= $(SRCDIR)/$(HOST_CT_NG).$(HOST_CT_NG_SUFFIX)
HOST_CT_NG_DIR	:= $(HOST_BUILDDIR)/$(HOST_CT_NG)

HOST_CT_NG_CONFIG	:= $(call remove_quotes, $(PTXDIST_PLATFORMCONFIGDIR)/$(PTXCONF_HOST_CT_NG_CONFIG))

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(HOST_CT_NG_SOURCE):
	@$(call targetinfo)
	@$(call get, HOST_CT_NG)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

HOST_CT_NG_PATH	:= PATH=$(HOST_PATH)
HOST_CT_NG_ENV 	:= KCONFIG_NOTIMESTAMP=1
HOST_CT_NG_MAKEVARS := \
	HOSTCC=$(HOSTCC) \
	ARCH=$(PTXCONF_HOST_CT_NG_ARCH_STRING) \

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/host-ct-ng.compile:
#	@$(call targetinfo)
#	cd $(HOST_CT_NG_DIR) && $(HOST_CT_NG_PATH) $(MAKE) $(HOST_CT_NG_MAKEVARS)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/host-ct-ng.install:
	@$(call targetinfo)
	@install -D -m755 $(HOST_CT_NG_DIR)/ct-ng $(PTXCONF_SYSROOT_HOST)/bin/ct-ng
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/host-ct-ng.targetinstall:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

$(STATEDIR)/host-ct-ng.clean:
	@$(call targetinfo)
	@$(call clean_pkg, HOST_CT_NG)

# vim: syntax=make
