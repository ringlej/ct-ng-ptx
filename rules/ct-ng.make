# -*-makefile-*-
#
# Copyright (C) 2010 by Marc Kleine-Budde <mkl@pengutronix.de>
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
CT_NG_VERSION	:= $(call remove_quotes,$(PTXCONF_CT_NG_VERSION))
CT_NG		:= crosstool-ng-$(CT_NG_VERSION)
CT_NG_SUFFIX	:= tar.bz2
CT_NG_URL	:= http://ymorin.is-a-geek.org/download/crosstool-ng/$(CT_NG).$(CT_NG_SUFFIX)
CT_NG_SOURCE	:= $(SRCDIR)/$(CT_NG).$(CT_NG_SUFFIX)
CT_NG_DIR	:= $(BUILDDIR)/$(CT_NG)
CT_NG_LICENSE	:= unknown

CT_NG_CONFIG	:= $(call remove_quotes, $(PTXDIST_PLATFORMCONFIGDIR)/$(PTXCONF_CT_NG_CONFIG))

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(CT_NG_SOURCE):
	@$(call targetinfo)
	@$(call get, CT_NG)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/ct-ng.extract:
	@$(call targetinfo)
	@mkdir -p "$(CT_NG_DIR)"
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

ct-ng_update_config = \
	if [ "$(CT_NG_CONFIG)" -nt "$(CT_NG_DIR)/.config" ]; then \
		if [ -e "$(CT_NG_CONFIG)" ]; then \
			install -m 644 $(CT_NG_CONFIG) $(CT_NG_DIR)/.config; \
		fi \
	elif [ "$(CT_NG_DIR)/.config" -nt "$(CT_NG_CONFIG)" ]; then \
		if [ -e "$(CT_NG_DIR)/.config" ]; then \
			sed -i "s|^\(CT_PREFIX_DIR=\)\(.*\)$$|\1\"/opt/crosstool-ng-${CT_NG_VERSION}/\$${CT_TARGET}/\$${CT_CC}-\$${CT_CC_VERSION}-\$${CT_LIBC}-\$${CT_LIBC_VERSION}-binutils-\$${CT_BINUTILS_VERSION}-kernel-\$${CT_KERNEL_VERSION}-sanitized\"|" $(CT_NG_DIR)/.config ;\
			sed -i "s|^\(CT_LOCAL_TARBALLS_DIR=\)\(.*\)$$|\1\"$(PTXDIST_SRCDIR)\"|" $(CT_NG_DIR)/.config ; \
			install -m 644 $(CT_NG_DIR)/.config $(CT_NG_CONFIG); \
			echo; \
			echo "**********************************************"; \
			echo "**** ct-ng.config file was updated        ****"; \
			echo "**** Please verify and tweak config with: ****"; \
			echo "****     'ptxdist menuconfig ct-ng'       ****"; \
			echo "**********************************************"; \
			echo; \
			echo; \
		fi \
	fi

ifdef PTXCONF_CT_NG
$(CT_NG_CONFIG):
	@echo
	@echo "***********************************************"
	@echo "**** Please generate a ct-ng.config:       ****"
	@echo "**** choose from a list of samples from:   ****"
	@echo "****     'ptxdist make ct-ng list-samples' ****"
	@echo "**** and select sample with:               ****"
	@echo "****     'ptxdist make ct-ng <sample>'     ****"
	@echo "**** then edit config with:                ****"
	@echo "****     'ptxdist menuconfig ct-ng'        ****"
	@echo "***********************************************"
	@echo
	@echo
	@exit 1
endif

$(STATEDIR)/ct-ng.prepare: $(CT_NG_CONFIG)
	@$(call targetinfo)
	@$(call ct-ng_update_config)

	@echo "Using ct-ng config file: $(CT_NG_CONFIG)"
#	@install -m 644 $(CT_NG_CONFIG) $(CT_NG_DIR)/.config

	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/ct-ng.compile:
	@$(call targetinfo)
#	@$(call world/compile, CT_NG)
	cd "$(CT_NG_DIR)" && \
		$(CT_NG_PATH) $(CT_NG_ENV) ct-ng build.$(PTXDIST_PARALLELMFLAGS_INTERN:-j%=%) $(CT_NG_MAKEVARS)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/ct-ng.install:
#	@$(call targetinfo)
#	@$(call world/install, CT_NG)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/ct-ng.targetinstall:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/ct-ng.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, CT_NG)

# ----------------------------------------------------------------------------
# oldconfig / menuconfig
# ----------------------------------------------------------------------------

ct-ng_oldconfig ct-ng_menuconfig: $(STATEDIR)/ct-ng.extract $(STATEDIR)/host-ct-ng.install
	@$(call ct-ng_update_config) > /dev/null
	@cd "$(CT_NG_DIR)" && \
		$(CT_NG_PATH) $(CT_NG_ENV) ct-ng $(CT_NG_MAKEVARS) $(subst ct-ng_,,$@)
	@if cmp -s "$(CT_NG_DIR)/.config" "$(CT_NG_CONFIG)"; then \
		echo "ct-ng configuration unchanged"; \
	else \
		cp "$(CT_NG_DIR)/.config" "$(CT_NG_CONFIG)"; \
	fi

ct-ng: $(STATEDIR)/ct-ng.extract $(STATEDIR)/host-ct-ng.install
	cd $(CT_NG_DIR) && $(CT_NG_PATH) $(CT_NG_ENV) ct-ng $(CT_NG_MAKEVARS) $(filter-out $@,$(MAKECMDGOALS))
	@$(call ct-ng_update_config)

# supress "no rule to make taret" errors
ifeq ($(filter ct-ng,$(MAKECMDGOALS)),ct-ng)
PHONY += $(MAKECMDGOALS)
$(filter-out ct-ng,$(MAKECMDGOALS)):
	@true
endif

# vim: syntax=make
