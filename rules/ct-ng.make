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
PACKAGES-$(PTXCONF_CT_NG) += ct-ng

#
# Paths and names
#
CT_NG_VERSION	:= $(HOST_CT_NG_VERSION)
CT_NG		:= crosstool-ng-$(CT_NG_VERSION)
CT_NG_DIR	:= $(BUILDDIR)/$(CT_NG)

CT_NG_CONFIG	:= $(call remove_quotes, $(PTXDIST_PLATFORMCONFIGDIR)/$(PTXCONF_CT_NG_CONFIG))

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(CT_NG_SOURCE):
#	@$(call targetinfo)
#	@$(call get, CT_NG)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

CT_NG_PATH	:= PATH=$(HOST_PATH)
CT_NG_ENV 	:= KCONFIG_NOTIMESTAMP=1
CT_NG_MAKEVARS := \
	HOSTCC=$(HOSTCC) \
	ARCH=$(PTXCONF_CT_NG_ARCH_STRING) \

ifdef PTXCONF_CT_NG
$(CT_NG_CONFIG):
	@echo
	@echo "*****************************************************************************"
	@echo "**** Please generate a ct-ng config with 'ptxdist menuconfig ct-ng' ****"
	@echo "*****************************************************************************"
	@echo
	@echo
	@exit 1
endif

$(STATEDIR)/ct-ng.prepare: $(CT_NG_CONFIG)
	@$(call targetinfo)

	@echo "Using ct-ng config file: $(CT_NG_CONFIG)"
	@install -m 644 $(CT_NG_CONFIG) $(CT_NG_DIR)/.config

	@$(call ptx/oldconfig, CT_NG)

	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/ct-ng.compile:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/ct-ng.install:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/ct-ng.targetinstall:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

$(STATEDIR)/ct-ng.clean:
	@$(call targetinfo)
	@$(call clean_pkg, CT_NG)


# ----------------------------------------------------------------------------
# oldconfig / menuconfig
# ----------------------------------------------------------------------------

ct-ng_oldconfig ct-ng_menuconfig:
	@if test -e $(CT_NG_CONFIG); then \
		cp $(CT_NG_CONFIG) $(CT_NG_DIR)/.config; \
	fi
	cd $(CT_NG_DIR) && \
		$(CT_NG_PATH) $(CT_NG_ENV) ct-ng $(CT_NG_MAKEVARS) $(subst ct-ng_,,$@)
	@if cmp -s $(CT_NG_DIR)/.config $(CT_NG_CONFIG); then \
		echo "ct-ng configuration unchanged"; \
	else \
		cp $(CT_NG_DIR)/.config $(CT_NG_CONFIG); \
	fi

# vim: syntax=make
