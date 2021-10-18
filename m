Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D16431FD1
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 16:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhJROgf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 10:36:35 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:42238 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhJROge (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 10:36:34 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 72FC71FD7F;
        Mon, 18 Oct 2021 14:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634567662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KD40xH8wMMOEidvhc9WfSNwH6dQ8IG7+ewsybIpRXNQ=;
        b=cURxUfb3eh7yRTTTJHnBhNy09QfO/ElQHjkiZ7jgnoaNfh6qXqZYoK76ikX5ZQR85ht59n
        BuyYqLBXXwBammvX2sxR3fOrGveg8FGXW52v6C6mPBpWV4hSfTkyHPNeau/5CMyRLx7SJc
        aJqtKw6GXLbdW0yTp4R71GEX+7Agx1k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634567662;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KD40xH8wMMOEidvhc9WfSNwH6dQ8IG7+ewsybIpRXNQ=;
        b=B3zP62X8Q19DpC/jfvgrjHQiFHBbUxjFhE0jmUonJnYrIT30USZ7O68wcCjLVofBflCe8f
        S7O6fQwpSA7T/jDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9038B13AFB;
        Mon, 18 Oct 2021 14:34:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Jjt+Au2FbWGZAgAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 18 Oct 2021 14:34:21 +0000
Subject: Re: misc bcache cleanups
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-bcache@vger.kernel.org
References: <20211018060934.1816088-1-hch@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <c07a7ecb-303e-5acd-8a6b-342c1ac99127@suse.de>
Date:   Mon, 18 Oct 2021 22:34:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211018060934.1816088-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/18/21 2:09 PM, Christoph Hellwig wrote:
> Hi Coly,
>
> this series has a bunch of misc cleanups for bcache by using better kernel
> interfaces.

Hi Christoph,

The last 2 patches are good to me. Do you want me to pick these two 
patches, or you handle them directly?

Thanks.

Coly Li

>
> Diffstat:
>   bcache.h  |    4 ----
>   btree.c   |    2 +-
>   debug.c   |   15 +++++++--------
>   io.c      |   16 ++++++++--------
>   request.c |    6 +++---
>   super.c   |   55 +++++++++++++++++++++++--------------------------------
>   sysfs.c   |    2 +-
>   util.h    |    8 --------
>   8 files changed, 43 insertions(+), 65 deletions(-)

