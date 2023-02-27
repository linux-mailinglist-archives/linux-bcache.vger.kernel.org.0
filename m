Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF02B6A3FF6
	for <lists+linux-bcache@lfdr.de>; Mon, 27 Feb 2023 12:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjB0LH1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 27 Feb 2023 06:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjB0LH0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Feb 2023 06:07:26 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF304C35
        for <linux-bcache@vger.kernel.org>; Mon, 27 Feb 2023 03:07:22 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5D9E9219B3;
        Mon, 27 Feb 2023 11:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677496041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QWIKirWDZ+K9vxETlIYguYmaLPMtNFxc5OAIXbhPDAk=;
        b=muLd+ip8Xe7kvAHd6MemnLQOjKUFxTeGCB+vA1ScQApZIOMFx259rrHwKGxxyHsEf8YXUC
        66ki6qteDOGYPH+xHie52U3PmCGUftjJYZBaxRWE/JN/uyxOukew600iWzEpTHRCLxMSZf
        A1WDv+ieFFeqqb+cN2jY8IqlIYbRjAs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677496041;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QWIKirWDZ+K9vxETlIYguYmaLPMtNFxc5OAIXbhPDAk=;
        b=PC/tY6HokNXIliQHcEPHsX/fi0N654RF2ALWv3aaLANTJRmv+XC8fr9ZeonxkLa6VmW6W/
        9gy5XPm804xvFAAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8782F13912;
        Mon, 27 Feb 2023 11:07:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9F11FeiO/GMLDgAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 27 Feb 2023 11:07:20 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH] bcache: Remove dead references to cache_readaheads
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230225153355.2779474-1-andrea.tomassetti-opensource@devo.com>
Date:   Mon, 27 Feb 2023 19:07:08 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <417B9691-D667-4F70-9DEF-19E84C70A2CC@suse.de>
References: <20230225153355.2779474-1-andrea.tomassetti-opensource@devo.com>
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B42=E6=9C=8825=E6=97=A5 23:33=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> The cache_readaheads stat counter is not used anymore and should be
> removed.
>=20
> Signed-off-by: Andrea Tomassetti =
<andrea.tomassetti-opensource@devo.com>

Nice cache, added to my for-next.

Thanks.

Coly Li



> ---
> Documentation/admin-guide/bcache.rst | 3 ---
> drivers/md/bcache/stats.h            | 1 -
> 2 files changed, 4 deletions(-)
>=20
> diff --git a/Documentation/admin-guide/bcache.rst =
b/Documentation/admin-guide/bcache.rst
> index bb5032a99234..6fdb495ac466 100644
> --- a/Documentation/admin-guide/bcache.rst
> +++ b/Documentation/admin-guide/bcache.rst
> @@ -508,9 +508,6 @@ cache_miss_collisions
>   cache miss, but raced with a write and data was already present =
(usually 0
>   since the synchronization for cache misses was rewritten)
>=20
> -cache_readaheads
> -  Count of times readahead occurred.
> -
> Sysfs - cache set
> ~~~~~~~~~~~~~~~~~
>=20
> diff --git a/drivers/md/bcache/stats.h b/drivers/md/bcache/stats.h
> index bd3afc856d53..21b445f8af15 100644
> --- a/drivers/md/bcache/stats.h
> +++ b/drivers/md/bcache/stats.h
> @@ -18,7 +18,6 @@ struct cache_stats {
> unsigned long cache_misses;
> unsigned long cache_bypass_hits;
> unsigned long cache_bypass_misses;
> - unsigned long cache_readaheads;
> unsigned long cache_miss_collisions;
> unsigned long sectors_bypassed;
>=20
> --=20
> 2.39.2
>=20

