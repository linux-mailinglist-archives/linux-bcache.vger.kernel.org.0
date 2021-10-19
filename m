Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BD3432D3F
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Oct 2021 07:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbhJSFeC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 19 Oct 2021 01:34:02 -0400
Received: from verein.lst.de ([213.95.11.211]:36626 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233363AbhJSFeB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 19 Oct 2021 01:34:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9ABEA68AFE; Tue, 19 Oct 2021 07:31:47 +0200 (CEST)
Date:   Tue, 19 Oct 2021 07:31:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, linux-bcache@vger.kernel.org
Subject: Re: misc bcache cleanups
Message-ID: <20211019053147.GA20206@lst.de>
References: <20211018060934.1816088-1-hch@lst.de> <c07a7ecb-303e-5acd-8a6b-342c1ac99127@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c07a7ecb-303e-5acd-8a6b-342c1ac99127@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Oct 18, 2021 at 10:34:18PM +0800, Coly Li wrote:
> On 10/18/21 2:09 PM, Christoph Hellwig wrote:
>> Hi Coly,
>>
>> this series has a bunch of misc cleanups for bcache by using better kernel
>> interfaces.
>
> Hi Christoph,
>
> The last 2 patches are good to me. Do you want me to pick these two 
> patches, or you handle them directly?

Can you send the series to Jens as a normal bcache pull request?
