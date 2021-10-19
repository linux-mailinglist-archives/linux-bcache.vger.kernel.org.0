Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693B6432E16
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Oct 2021 08:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbhJSGYN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 19 Oct 2021 02:24:13 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:35496 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhJSGYM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 19 Oct 2021 02:24:12 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B8FA81FD8D;
        Tue, 19 Oct 2021 06:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634624519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t+JKuVpnj6vJXgBCTvozzdniXvMuM3Nx89VsPDmgVvQ=;
        b=GvUo2mdK28OG52gmKuOrDQYX9bE0Ot2ljaCpjZDN5Lrt30dKNSdDsA7P2CaYuE4UxJbMEc
        /6P0LOOP3k40lNiRC5JqybkvYNGyMt4Tw9zIVvMkYjBpqaDLHK6OEz2OVV1AzyHC3kPEvh
        5lggB0XyLnywsu1aZMInn/ga6JDMxWk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634624519;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t+JKuVpnj6vJXgBCTvozzdniXvMuM3Nx89VsPDmgVvQ=;
        b=ED+ZXU+GFHnSjngnpcR6XeVpnfzQYaqdU31OlqaMWrY6jCdnWrZ3al0IEt0Y7BEEewj0Ts
        Dr65iZwawY2KU8DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 09D6613CEE;
        Tue, 19 Oct 2021 06:21:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EOivMQZkbmEsVAAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 19 Oct 2021 06:21:58 +0000
Subject: Re: misc bcache cleanups
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-bcache@vger.kernel.org
References: <20211018060934.1816088-1-hch@lst.de>
 <c07a7ecb-303e-5acd-8a6b-342c1ac99127@suse.de>
 <20211019053147.GA20206@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <72da2da7-aea3-0186-4176-fd4ac98bb4bd@suse.de>
Date:   Tue, 19 Oct 2021 14:21:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019053147.GA20206@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/19/21 1:31 PM, Christoph Hellwig wrote:
> On Mon, Oct 18, 2021 at 10:34:18PM +0800, Coly Li wrote:
>> On 10/18/21 2:09 PM, Christoph Hellwig wrote:
>>> Hi Coly,
>>>
>>> this series has a bunch of misc cleanups for bcache by using better kernel
>>> interfaces.
>> Hi Christoph,
>>
>> The last 2 patches are good to me. Do you want me to pick these two
>> patches, or you handle them directly?
> Can you send the series to Jens as a normal bcache pull request?

Sure, I pick them. Thanks.

Coly Li
