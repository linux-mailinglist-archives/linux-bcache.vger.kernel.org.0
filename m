Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035864322EB
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 17:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbhJRPem (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 11:34:42 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47644 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhJRPel (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 11:34:41 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B6C321FD7F;
        Mon, 18 Oct 2021 15:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634571149; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=godHUAyiLRy59Rqrk9Sk/KvK+G9suw6Zrxnhk+UGCXY=;
        b=1a1HuohP8ZkGJeADevl1aamEA8jrCjFVj48FKhIwjdMDM/JkYf7CLC7zoApIi6Bo/YvnnY
        mER903qPyTa/G6s92TfUi35Z51tpJCRBTx0ycs4wqvhAW8u08UQJ4WG3SktoFbhW3v+x+F
        DYdQ84a28JJ/HSHUixrLztkgjPLkY0k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634571149;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=godHUAyiLRy59Rqrk9Sk/KvK+G9suw6Zrxnhk+UGCXY=;
        b=ZjqGqRMz2kuLBCa+wVmAoIzpTG2VG/MEeMWW9DE+tUzaIF9VJpR9uFAwDXGS7sw3zFkSrP
        RFWoU2bu+WLHnfDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0A8F013E74;
        Mon, 18 Oct 2021 15:32:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AFfyHIyTbWG+IAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 18 Oct 2021 15:32:28 +0000
Subject: Re: [PATCH 1/4] bcache: remove the cache_dev_name field from struct
 cache
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-bcache@vger.kernel.org
References: <20211018060934.1816088-1-hch@lst.de>
 <20211018060934.1816088-2-hch@lst.de>
 <dc8601a6-21a5-3680-7489-1430d14788db@suse.de>
 <20211018152127.GA31195@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <8c9e20f7-7a58-9ee7-c592-63d5a6162f94@suse.de>
Date:   Mon, 18 Oct 2021 23:32:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211018152127.GA31195@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/18/21 11:21 PM, Christoph Hellwig wrote:
> On Mon, Oct 18, 2021 at 10:26:18PM +0800, Coly Li wrote:
>> On 10/18/21 2:09 PM, Christoph Hellwig wrote:
>>> Just use the %pg format specifier to print the name directly.
>> Hi  Christoph,
>>
>> NACK for this patch.  The buffer cache_dev_name is added on purpose, in
>> case ca->bdev cannot be referenced correctly for some special condition
>> when underlying device fails.
> Where exactly?  ->bdev is never cleared and only dropped after we
> waited for the I/O to complete.

It was in Linux v4.17 time, when I did the device failure handling. If 
the underlying device broken and gone, printing the device name string 
will be a "null" string in kmesg. But the device name was necessary for 
proper device failure information, we stored the device name string when 
it was initialized.

Coly Li
