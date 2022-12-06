Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C15644C14
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Dec 2022 19:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiLFS4E (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Dec 2022 13:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLFSzn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Dec 2022 13:55:43 -0500
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D66336C57;
        Tue,  6 Dec 2022 10:55:42 -0800 (PST)
Received: by mail-pf1-f177.google.com with SMTP id g1so7333394pfk.2;
        Tue, 06 Dec 2022 10:55:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lPHt//IGe+mjUQhKRlsPO2uaXa6rXyJmJ4qRK45NUH0=;
        b=5rCUZ75ljOcYumPfs7ZjGm6ra6MM9I4Zd4FKNys6yCv5azNvmHCvQG9uL4zGWG3MPO
         FXakoUFy4vF5qELPKxUmfYr+f9DwBxVMoDwgJ7YjozcQYbbNT4LuFZAQ4FK9xWSWFXFZ
         cYUioDtiAJZPeb2k8/DR0WHbCl5TY2LFyYChSLjiVUrGTWFP/TT0ytmic4P47XyObNvg
         v8YhOToVxv4fOWiAigf0wIo/yqXiZewUdJ2TTQ1iEE+tWuKj0CKxBRwAzJ+MNSb4y88r
         lg2Ujcjb6PUOksDFthwDSk1eQkYg24kxsVKl/TRha1xNSY12AGmEZ8LFZL4VA8Mx2TNs
         +Axw==
X-Gm-Message-State: ANoB5pm0z2cPqJCd0eUq2qKejTxG4wAaw3st+5jdvSdBJ8TwjcOB12KZ
        G60J5CyHnnzFnhAUmxKfOkYO7kl1PCQ=
X-Google-Smtp-Source: AA0mqf6bx+k2Mb8T/uAbgfD3OZP6qWdpYvnAIuVEpOWbtMWqssGy8l6Nv8AdnxnwAPdrxTlUU1tumA==
X-Received: by 2002:a63:5802:0:b0:46f:59af:c1f4 with SMTP id m2-20020a635802000000b0046f59afc1f4mr61219109pgb.344.1670352941888;
        Tue, 06 Dec 2022 10:55:41 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:6220:45e1:53d2:e1cb? ([2620:15c:211:201:6220:45e1:53d2:e1cb])
        by smtp.gmail.com with ESMTPSA id x14-20020a170902ec8e00b0017c37a5a2fdsm12983682plg.216.2022.12.06.10.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 10:55:41 -0800 (PST)
Message-ID: <5769762e-c15e-b111-e205-38d477e681f3@acm.org>
Date:   Tue, 6 Dec 2022 10:55:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] block: remove bio_set_op_attrs
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, snitzer@kernel.org
Cc:     colyli@suse.de, song@kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com
References: <20221206144057.720846-1-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221206144057.720846-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/6/22 06:40, Christoph Hellwig wrote:
> This macro is obsolete, so replace the last few uses with open coded
> bi_opf assignments.

For the entire patch:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
