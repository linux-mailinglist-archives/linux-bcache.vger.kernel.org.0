Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151F943231A
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 17:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhJRPlG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 11:41:06 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:35056 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232785AbhJRPlF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 11:41:05 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C2EAF21961;
        Mon, 18 Oct 2021 15:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634571533; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2u3WbniHuqszZkNzE40XayZ2vvY6Tk/HAbPlR/cURnU=;
        b=ub/0AcSh6njwY79lgNzpryTCcim4xTC8TwxMojKuzi297dqRM1JGpYXMBMwZMNLth+jn19
        nEGyh6G/gcO9RHyOvD1WOd9TsIM7kiu1ha2EbmZP/ZDC4Ao7KMdTm+Vi9c8VIZMoyyAH2z
        iBuhIHc7F+CrR93wuxB51qHlUqneGhk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634571533;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2u3WbniHuqszZkNzE40XayZ2vvY6Tk/HAbPlR/cURnU=;
        b=WS0r+/DDynifD7m0FSFzoNU2SOWN2A8gBSjyRFyzDd34wvBR4tbufkqKHNmtGSQ8a2RGZa
        lDWUnpTEnIEfalCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 196A8140B5;
        Mon, 18 Oct 2021 15:38:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GWW/NQyVbWGOIwAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 18 Oct 2021 15:38:52 +0000
Subject: Re: [PATCH 1/4] bcache: remove the cache_dev_name field from struct
 cache
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-bcache@vger.kernel.org
References: <20211018060934.1816088-1-hch@lst.de>
 <20211018060934.1816088-2-hch@lst.de>
 <dc8601a6-21a5-3680-7489-1430d14788db@suse.de>
 <20211018152127.GA31195@lst.de>
 <8c9e20f7-7a58-9ee7-c592-63d5a6162f94@suse.de>
 <20211018153514.GA32633@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <8b355bba-5110-5dff-fcf6-dd089b6301d0@suse.de>
Date:   Mon, 18 Oct 2021 23:38:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211018153514.GA32633@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/18/21 11:35 PM, Christoph Hellwig wrote:
> On Mon, Oct 18, 2021 at 11:32:26PM +0800, Coly Li wrote:
>> It was in Linux v4.17 time, when I did the device failure handling. If the
>> underlying device broken and gone, printing the device name string will be
>> a "null" string in kmesg. But the device name was necessary for proper
>> device failure information, we stored the device name string when it was
>> initialized.
> I'm pretty sure that was before the %pg specifier and the
> hd_struct/block_device unification.  With the current code there is no
> way it could print null.

Cool. Please add my acked-by to the first 2 patches,

Acked-by: Coly Li <colyli@suse.de>

Thanks for the hint.

Coly Li
