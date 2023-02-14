Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7716967E9
	for <lists+linux-bcache@lfdr.de>; Tue, 14 Feb 2023 16:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbjBNPV7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 14 Feb 2023 10:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbjBNPVw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Feb 2023 10:21:52 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525D12BF05;
        Tue, 14 Feb 2023 07:21:30 -0800 (PST)
Date:   Tue, 14 Feb 2023 15:21:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1676388087;
        bh=8z2YLstxDpMVDRO2lBBkldS2HswlOrxMU3qxVofMseM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZeBcXLK4XRxtgmQoNlPZMIpg7AkWcBhyJDjsOrFkWNLb4BzMf+KBxopwXMBnUnLmc
         cReAs9LbWamXYAtz41cGtT78b/tI2eQJ6Axpy+1n559ItmphYXh+6AYrLX0Or+wq1O
         Dl1GI9bIFSDUdUD1DU+U5Tx2o5N9/wSH7TQ25hD4=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To:     Coly Li <colyli@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcache: make kobj_type structures constant
Message-ID: <20230214152119.epkfhkojqjvokqmv@t-8ch.de>
References: <20230214-kobj_type-bcache-v1-1-cf00ead7bee7@weissschuh.net>
 <125CA8D6-D3B7-42FB-83BE-DCA688F2ACAF@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <125CA8D6-D3B7-42FB-83BE-DCA688F2ACAF@suse.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Feb 14, 2023 at 05:51:09PM +0800, Coly Li wrote:
> 
> 
> > 2023年2月14日 11:13，Thomas Weißschuh <linux@weissschuh.net> 写道：
> > 
> > Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.")
> > the driver core allows the usage of const struct kobj_type.
> > 
> > Take advantage of this to constify the structure definitions to prevent
> > modification at runtime.
> > 
> 
> How the const structure definition can prevent modification at run time?

It will be put into .rodata instead of .data by the compiler.
The .rodata section is mapped as read-only via the pagetable.

See Documentation/security/self-protection.rst
"Function pointers and sensitive variables must not be writable".

Thomas

> Thanks.
> 
> Coly Li
> 
> 
> > Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
> > ---
> > drivers/md/bcache/bcache.h | 10 +++++-----
> > drivers/md/bcache/sysfs.h  |  2 +-
> > 2 files changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> > index aebb7ef10e63..a522f4f1f992 100644
> > --- a/drivers/md/bcache/bcache.h
> > +++ b/drivers/md/bcache/bcache.h
> > @@ -1004,11 +1004,11 @@ extern struct workqueue_struct *bch_flush_wq;
> > extern struct mutex bch_register_lock;
> > extern struct list_head bch_cache_sets;
> > 
> > -extern struct kobj_type bch_cached_dev_ktype;
> > -extern struct kobj_type bch_flash_dev_ktype;
> > -extern struct kobj_type bch_cache_set_ktype;
> > -extern struct kobj_type bch_cache_set_internal_ktype;
> > -extern struct kobj_type bch_cache_ktype;
> > +extern const struct kobj_type bch_cached_dev_ktype;
> > +extern const struct kobj_type bch_flash_dev_ktype;
> > +extern const struct kobj_type bch_cache_set_ktype;
> > +extern const struct kobj_type bch_cache_set_internal_ktype;
> > +extern const struct kobj_type bch_cache_ktype;
> > 
> > void bch_cached_dev_release(struct kobject *kobj);
> > void bch_flash_dev_release(struct kobject *kobj);
> > diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
> > index a2ff6447b699..65b8bd975ab1 100644
> > --- a/drivers/md/bcache/sysfs.h
> > +++ b/drivers/md/bcache/sysfs.h
> > @@ -3,7 +3,7 @@
> > #define _BCACHE_SYSFS_H_
> > 
> > #define KTYPE(type) \
> > -struct kobj_type type ## _ktype = { \
> > +const struct kobj_type type ## _ktype = { \
> > .release = type ## _release, \
> > .sysfs_ops = &((const struct sysfs_ops) { \
> > .show = type ## _show, \
> > 
> > ---
> > base-commit: f6feea56f66d34259c4222fa02e8171c4f2673d1
> > change-id: 20230214-kobj_type-bcache-6d2bd129b0fa
> > 
> > Best regards,
> > -- 
> > Thomas Weißschuh <linux@weissschuh.net>
> > 
> 
